class LuaAT51 < Formula
  # 5.3 is not fully backwards compatible so we must retain 2 Luas for now.
  desc "Powerful, lightweight programming language (v5.1.5)"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.1.5.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/lua5.1/lua5.1_5.1.5.orig.tar.gz"
  sha256 "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333"
  revision 8

  bottle do
    cellar :any
    sha256 "4578b515c3e1a255f766d7fa542e632007ac2de8282e207b92192d0bb9bafd11" => :mojave
    sha256 "d374b94b3e4b9af93cb5c04086f4a9836c06953b4b1941c68a92986ba57356b1" => :high_sierra
    sha256 "67ce3661b56fe8dd0daf6f94b7da31a9516b00ae85d9bbe9eabd7ed2e1dbb324" => :sierra
    sha256 "e43d1c75fe4462c5dca2d95ebee9b0e4897c872f03c4331d5898a06a408cbcb3" => :el_capitan
  end

  option "with-completion", "Enables advanced readline support"
  option "without-sigaction", "Revert to ANSI signal instead of improved POSIX sigaction"

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/homebrew/pull/5043
  patch :DATA

  # sigaction provided by posix signalling power patch from
  # http://lua-users.org/wiki/LuaPowerPatches
  if build.with? "completion"
    patch do
      url "http://lua-users.org/files/wiki_insecure/power_patches/5.1/sig_catch.patch"
      sha256 "221435dedd84a386e2d40454e6260a678286bfb7128afa18a4339e5fdda9c8f2"
    end
  end

  # completion provided by advanced readline power patch from
  # http://lua-users.org/wiki/LuaPowerPatches
  if build.with? "completion"
    patch do
      url "https://luajit.org/patches/lua-5.1.4-advanced_readline.patch"
      sha256 "dfd17e720d1079dcb64529af3e4fea4a4abc0115c934f365282a489d134cceb4"
    end
  end

  def install
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.gsub! "@LUA_PREFIX@", prefix
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS", "#{ENV.cflags} $(MYCFLAGS)"
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
      s.sub! "MYCFLAGS_VAL", "-fno-common -DLUA_USE_LINUX"
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    # Fix paths in the .pc
    inreplace "etc/lua.pc" do |s|
      s.gsub! "prefix= /usr/local", "prefix=#{HOMEBREW_PREFIX}"
      s.gsub! "INSTALL_MAN= ${prefix}/man/man1", "INSTALL_MAN= ${prefix}/share/man/man1"
      s.gsub! "INSTALL_INC= ${prefix}/include", "INSTALL_INC= ${prefix}/include/lua-5.1"
      s.gsub! "includedir=${prefix}/include", "includedir=${prefix}/include/lua-5.1"
      s.gsub! "Libs: -L${libdir} -llua -lm", "Libs: -L${libdir} -llua.5.1 -lm"
    end

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}", "INSTALL_INC=#{include}/lua-5.1"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}", "INSTALL_INC=#{include}/lua-5.1"

    (lib/"pkgconfig").install "etc/lua.pc"

    # Renaming from Lua to Lua51.
    # Note that the naming must be both lua-version & lua.version.
    # Software can't find the libraries without supporting both the
    # hyphen and full stop.
    mv bin/"lua", bin/"lua-5.1"
    mv bin/"luac", bin/"luac-5.1"
    mv man1/"lua.1", man1/"lua-5.1.1"
    mv man1/"luac.1", man1/"luac-5.1.1"
    mv lib/"pkgconfig/lua.pc", lib/"pkgconfig/lua-5.1.pc"
    bin.install_symlink "lua-5.1" => "lua5.1"
    bin.install_symlink "luac-5.1" => "luac5.1"
    include.install_symlink "lua-5.1" => "lua5.1"
    (lib/"pkgconfig").install_symlink "lua-5.1.pc" => "lua5.1.pc"
    (libexec/"lib/pkgconfig").install_symlink lib/"pkgconfig/lua-5.1.pc" => "lua.pc"
  end

  def caveats; <<~EOS
    You may also want luarocks:
      brew install luarocks
  EOS
  end

  test do
    system "#{bin}/lua5.1", "-e", "print ('Ducks are cool')"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 209a132..9387b09 100644
--- a/Makefile
+++ b/Makefile
@@ -43,7 +43,7 @@ PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris
 # What to install.
 TO_BIN= lua luac
 TO_INC= lua.h luaconf.h lualib.h lauxlib.h ../etc/lua.hpp
-TO_LIB= liblua.a
+TO_LIB= liblua.5.1.5.dylib
 TO_MAN= lua.1 luac.1

 # Lua version and release.
@@ -64,6 +64,8 @@ install: dummy
	cd src && $(INSTALL_DATA) $(TO_INC) $(INSTALL_INC)
	cd src && $(INSTALL_DATA) $(TO_LIB) $(INSTALL_LIB)
	cd doc && $(INSTALL_DATA) $(TO_MAN) $(INSTALL_MAN)
+	ln -s -f liblua.5.1.5.dylib $(INSTALL_LIB)/liblua.5.1.dylib
+	ln -s -f liblua.5.1.dylib $(INSTALL_LIB)/liblua5.1.dylib

 ranlib:
	cd src && cd $(INSTALL_LIB) && $(RANLIB) $(TO_LIB)
diff --git a/src/Makefile b/src/Makefile
index e0d4c9f..4477d7b 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -22,7 +22,7 @@ MYLIBS=

 PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris

-LUA_A=	liblua.a
+LUA_A=	liblua.5.1.5.dylib
 CORE_O=	lapi.o lcode.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o \
	lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o  \
	lundump.o lvm.o lzio.o
@@ -48,11 +48,13 @@ o:	$(ALL_O)
 a:	$(ALL_A)

 $(LUA_A): $(CORE_O) $(LIB_O)
-	$(AR) $@ $(CORE_O) $(LIB_O)	# DLL needs all object files
-	$(RANLIB) $@
+	$(CC) -dynamiclib -install_name @LUA_PREFIX@/lib/liblua.5.1.dylib \
+		-compatibility_version 5.1 -current_version 5.1.5 \
+		-o liblua.5.1.5.dylib $^

 $(LUA_T): $(LUA_O) $(LUA_A)
-	$(CC) -o $@ $(MYLDFLAGS) $(LUA_O) $(LUA_A) $(LIBS)
+	$(CC) -fno-common $(MYLDFLAGS) \
+		-o $@ $(LUA_O) $(LUA_A) -L. -llua.5.1.5 $(LIBS)

 $(LUAC_T): $(LUAC_O) $(LUA_A)
	$(CC) -o $@ $(MYLDFLAGS) $(LUAC_O) $(LUA_A) $(LIBS)
@@ -99,7 +101,7 @@ linux:
	$(MAKE) all MYCFLAGS=-DLUA_USE_LINUX MYLIBS="-Wl,-E -ldl -lreadline -lhistory -lncurses"

 macosx:
-	$(MAKE) all MYCFLAGS=-DLUA_USE_LINUX MYLIBS="-lreadline"
+	$(MAKE) all MYCFLAGS="MYCFLAGS_VAL" MYLIBS="-lreadline"
 # use this on Mac OS X 10.3-
 #	$(MAKE) all MYCFLAGS=-DLUA_USE_MACOSX
