
function! J6uil#cache_manager#new()
  return deepcopy(s:cache_manager)
endfunction

let s:cache_manager = {
      \  '_cache' : {},
      \  }

let s:cache = {
      \  'messages' : [],
      \  'members'  : [],
      \ }

function! s:cache_manager.cache_presence(room, presences)

  if type(a:presences) != 3
    let presences = [a:presences]
  else
    let presences = a:presences
  endif

  echomsg 'cache presences : ' . a:room

  for presence in presences
    let cache = self._get_cache(a:room)

    let ev = {
      \ 'name'      : has_key(presence, 'name')      ? presence.name      : presence.nickname,
      \ 'is_online' : has_key(presence, 'is_online') ? presence.is_online : presence.status == 'online',
      \ 'is_owner'  : has_key(presence, 'is_owner')  ? presence.is_owner  : 0,
      \ }

    let flg = 0
    for member in cache.members
      if member.name == ev.name
        let member.is_online = ev.is_online
        let flg = 1
        break
      endif
    endfor
    if !flg
      echomsg 'added ' . ev.name
      call add(cache.members, ev)
    end
  endfor
endfunction

function! s:cache_manager.get_members(room)
  return self._get_cache(a:room).members
endfunction

function! s:cache_manager._get_cache(room)

  "if type(a:key) == 1
    "let room = a:key
  "elseif has_key(a:key, 'room')
    "let room = a:key.room
  "else
    "let room = has_key(a:key, 'message') ? a:key.message.room : a:key.presence.room
  "endif
  "
  let room = a:room

  if !has_key(self._cache, room)
    let self._cache[room] = deepcopy(s:cache)
  endif

  return self._cache[room]
endfunction
