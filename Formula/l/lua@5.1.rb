class LuaAT51 < Formula
  # 5.3 is not fully backwards compatible so we must retain 2 Luas for now.
  desc "Powerful, lightweight programming language (v5.1.5)"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.1.5.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/l/lua5.1/lua5.1_5.1.5.orig.tar.gz"
  sha256 "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333"
  license "MIT"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "221199ff4dc562096e2a5132a4253932133496ab26e77e433fffb98134ed2dae"
    sha256 cellar: :any,                 arm64_ventura:  "0a376241fb0501719b36ebd1f2124e1c32b784bc59897c824f54567614d24ed5"
    sha256 cellar: :any,                 arm64_monterey: "de6f49207593ea1ff60752fbda844d4be34d92de796f758c9e0e5f3dd329fab7"
    sha256 cellar: :any,                 arm64_big_sur:  "cde11765109e69c6484206f4b2a63081b535253f32233471343f03b52505a89b"
    sha256 cellar: :any,                 sonoma:         "be4f7a95bce12da58d1d328803524523fd50a5e30727713b698851747997a26c"
    sha256 cellar: :any,                 ventura:        "f3b2b3317f5f291f523a1b4d049b5b9f966d7d7c7d4c4d5afa5f100791c58b91"
    sha256 cellar: :any,                 monterey:       "38413995d200a915e9d40831983b3605be0b1afcdb62fb0e768ca38c69b62dab"
    sha256 cellar: :any,                 big_sur:        "0d00a4c74d8e5fd3cd36621d318d2c1031a16c5701d2ae669223a2ca8a1a576d"
    sha256 cellar: :any,                 catalina:       "bbc328f48c0cf137907ccabe206f75cc7ade66cf76cafe82ced3a5f885c73da8"
    sha256 cellar: :any,                 mojave:         "4578b515c3e1a255f766d7fa542e632007ac2de8282e207b92192d0bb9bafd11"
    sha256 cellar: :any,                 high_sierra:    "d374b94b3e4b9af93cb5c04086f4a9836c06953b4b1941c68a92986ba57356b1"
    sha256 cellar: :any,                 sierra:         "67ce3661b56fe8dd0daf6f94b7da31a9516b00ae85d9bbe9eabd7ed2e1dbb324"
    sha256 cellar: :any,                 el_capitan:     "e43d1c75fe4462c5dca2d95ebee9b0e4897c872f03c4331d5898a06a408cbcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5ebc378db8f01127fdec3922b58252ede872cd6b70cbbde2adde311f1f699a"
  end

  uses_from_macos "unzip"

  on_macos do
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/Homebrew/homebrew/pull/5043
    patch :DATA
  end

  on_linux do
    depends_on "readline"

    # Add shared library for linux
    # Equivalent to the mac patch carried around here ... that will probably never get upstreamed
    patch do
      url "https://gist.githubusercontent.com/iMichka/0f389e65e5abd63bfc6073bfa76082b0/raw/6e9c4c4690c737d93a376e053bcb82cdd69aac3b/lua5.1.5.patch"
      sha256 "342b0d08eea9b9836be49fc88b3518cf207ee0e9aea09a248d3620c0b34e8e44"
    end
  end

  def install
    if OS.linux?
      # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
      # when making a shared object; recompile with -fPIC
      # See https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
      ENV.append_to_cflags "-fPIC"
    end

    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      if OS.mac?
        s.gsub! "@LUA_PREFIX@", prefix
        s.sub! "MYCFLAGS_VAL", "-fno-common -DLUA_USE_LINUX"
      end
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS", "#{ENV.cflags} $(MYCFLAGS)"
      s.change_make_var! "MYLDFLAGS", ENV.ldflags || ""
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

    os = if OS.mac?
      "macosx"
    else
      "linux"
    end

    args = [
      "INSTALL_TOP=#{prefix}",
      "INSTALL_MAN=#{man1}",
      "INSTALL_INC=#{include}/lua-5.1",
    ]

    system "make", os, *args
    args << "TO_LIB=liblua.so.5.1.5" if OS.linux?
    system "make", "install", *args

    (lib/"pkgconfig").install "etc/lua.pc"

    # Renaming from Lua to Lua51.
    # NOTE: The naming must be both lua-version & lua.version.
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

    if OS.linux?
      # Hack around wrong .so file naming
      %w[.so.5.1 .5.1.5.so .5.1.so 5.1.so].each do |suffix|
        lib.install_symlink "liblua.so.5.1.5" => "liblua#{suffix}"
      end
    end
  end

  def caveats
    <<~EOS
      You may also want luarocks:
        brew install luarocks
    EOS
  end

  test do
    system bin/"lua5.1", "-e", "print ('Ducks are cool')"
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
