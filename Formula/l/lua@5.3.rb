class LuaAT53 < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.3.6.tar.gz"
  sha256 "fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "5ff953a8fbc268b3b142fe27c9f33166412f4abb9e3270e37466ab11da65727d"
    sha256 cellar: :any,                 arm64_sonoma:   "7c5ee711b59688b6d0663a06fbe7029d5f82b3bb17203883f7359eeef70cc23c"
    sha256 cellar: :any,                 arm64_ventura:  "7644320966d9d947a316aaf416a4f8584b300b8e69d504756b36dab4174d2624"
    sha256 cellar: :any,                 arm64_monterey: "c8b7e58e974dbd961e98ca2454e079834d9ab587a8793421541d9f3819b94499"
    sha256 cellar: :any,                 arm64_big_sur:  "e06800c163acfcb6a1d0201ca303a631b8fef9c9047855c59795f015d23bd52b"
    sha256 cellar: :any,                 sonoma:         "8b7fbef25a004a71dbaaccd0fba7ede0b038e89c5e0f5b3ec10bdd33f2540512"
    sha256 cellar: :any,                 ventura:        "a6929c7f125dd6fd6bf764956325bc5d0067808eb1300ebe42e5a8e90815f8e1"
    sha256 cellar: :any,                 monterey:       "dd559951c01f28022e4d2a9729f4eb2f94803d365ff272ab3c361e06490cdfee"
    sha256 cellar: :any,                 big_sur:        "ce0820b10f9329826746487c3d69c475241cc7153dcbae1b250e853320256c27"
    sha256 cellar: :any,                 catalina:       "7ac8234731edf3b0eb86a20cda2bdb6c0de637529790263d076de7da6cc7ab93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab7e95e006b66d91b3dd4328202d5fe4769be8be19c72a02f63a94fa838ba5e"
  end

  keg_only :versioned_formula

  # See: https://www.lua.org/versions.html#5.3
  # Last release on 2020-09-25
  disable! date: "2024-12-14", because: :deprecated_upstream

  uses_from_macos "unzip" => :build

  on_macos do
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
    # ***Update me with each version bump!***
    patch :DATA
  end

  on_linux do
    depends_on "readline"

    # Add shared library for linux
    # Equivalent to the mac patch carried around here ... that will probably never get upstreamed
    # Inspired from https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/lua@5.3/lua-so.patch"
      sha256 "b9bba9d10ed5d34335c831972a02ec48471ca1dbf95230edc13fe5f575d5542c"
    end
  end

  def install
    if OS.linux?
      # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
      # when making a shared object; recompile with -fPIC
      # See https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
      ENV.append_to_cflags "-fPIC"
    end

    # Substitute formula prefix in `src/Makefile` for install name (dylib ID).
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.gsub! "@LUA_PREFIX@", prefix if OS.mac?
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS", "#{ENV.cflags} -DLUA_COMPAT_5_2 $(SYSCFLAGS) $(MYCFLAGS)"
      s.change_make_var! "MYLDFLAGS", ENV.ldflags || ""
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    os = if OS.mac?
      "macosx"
    else
      "linux"
    end

    system "make", os, "INSTALL_TOP=#{prefix}", "INSTALL_INC=#{include}/lua", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_INC=#{include}/lua", "INSTALL_MAN=#{man1}"

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    libs = %W[-llua#{version.major_minor} -lm]
    libs << "-ldl" if OS.linux?
    (lib/"pkgconfig/lua.pc").write <<~EOS
      V= #{version.major_minor}
      R= #{version}
      prefix=#{opt_prefix}
      INSTALL_BIN= ${prefix}/bin
      INSTALL_INC= ${prefix}/include/lua
      INSTALL_LIB= ${prefix}/lib
      INSTALL_MAN= ${prefix}/share/man/man1
      INSTALL_LMOD= ${prefix}/share/lua/${V}
      INSTALL_CMOD= ${prefix}/lib/lua/${V}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/lua

      Name: Lua
      Description: An Extensible Extension Language
      Version: #{version}
      Requires:
      Libs: -L${libdir} #{libs.join(" ")}
      Cflags: -I${includedir}
    EOS

    # Fix some software potentially hunting for different pc names.
    bin.install_symlink "lua" => "lua#{version.major_minor}"
    bin.install_symlink "lua" => "lua-#{version.major_minor}"
    bin.install_symlink "luac" => "luac#{version.major_minor}"
    bin.install_symlink "luac" => "luac-#{version.major_minor}"
    (include/"lua#{version.major_minor}").install_symlink Dir[include/"lua/*"]
    lib.install_symlink shared_library("liblua", version.major_minor.to_s) => shared_library("liblua#{version.major_minor}")
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua#{version.major_minor}.pc"
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua-#{version.major_minor}.pc"

    lib.install Dir[shared_library("src/liblua", "*")] if OS.linux?
  end

  def caveats
    <<~EOS
      You may also want luarocks:
        brew install luarocks
    EOS
  end

  test do
    assert_match "Ducks are terrifying.", shell_output("#{bin}/lua -e \"print ('Ducks are terrifying.')\"")
  end
end

__END__
diff --git a/Makefile b/Makefile
index 7fa91c8..a825198 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,7 @@ PLATS= aix bsd c89 freebsd generic linux macosx mingw posix solaris
 # What to install.
 TO_BIN= lua luac
 TO_INC= lua.h luaconf.h lualib.h lauxlib.h lua.hpp
-TO_LIB= liblua.a
+TO_LIB= liblua.5.3.6.dylib
 TO_MAN= lua.1 luac.1

 # Lua version and release.
@@ -63,6 +63,8 @@ install: dummy
	cd src && $(INSTALL_DATA) $(TO_INC) $(INSTALL_INC)
	cd src && $(INSTALL_DATA) $(TO_LIB) $(INSTALL_LIB)
	cd doc && $(INSTALL_DATA) $(TO_MAN) $(INSTALL_MAN)
+	ln -s -f liblua.5.3.6.dylib $(INSTALL_LIB)/liblua.5.3.dylib
+	ln -s -f liblua.5.3.dylib $(INSTALL_LIB)/liblua.dylib

 uninstall:
	cd src && cd $(INSTALL_BIN) && $(RM) $(TO_BIN)
diff --git a/src/Makefile b/src/Makefile
index 2e7a412..d0c4898 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -28,7 +28,7 @@ MYOBJS=

 PLATS= aix bsd c89 freebsd generic linux macosx mingw posix solaris

-LUA_A=	liblua.a
+LUA_A=	liblua.5.3.6.dylib
 CORE_O=	lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o \
	lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o \
	ltm.o lundump.o lvm.o lzio.o
@@ -56,11 +56,12 @@ o:	$(ALL_O)
 a:	$(ALL_A)

 $(LUA_A): $(BASE_O)
-	$(AR) $@ $(BASE_O)
-	$(RANLIB) $@
+	$(CC) -dynamiclib -install_name @LUA_PREFIX@/lib/liblua.5.3.dylib \
+		-compatibility_version 5.3 -current_version 5.3.6 \
+		-o liblua.5.3.6.dylib $^

 $(LUA_T): $(LUA_O) $(LUA_A)
-	$(CC) -o $@ $(LDFLAGS) $(LUA_O) $(LUA_A) $(LIBS)
+	$(CC) -fno-common $(MYLDFLAGS) -o $@ $(LUA_O) $(LUA_A) -L. -llua.5.3.6 $(LIBS)

 $(LUAC_T): $(LUAC_O) $(LUA_A)
	$(CC) -o $@ $(LDFLAGS) $(LUAC_O) $(LUA_A) $(LIBS)
@@ -110,7 +111,7 @@ linux:
	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_LINUX" SYSLIBS="-Wl,-E -ldl -lreadline"

 macosx:
-	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_MACOSX" SYSLIBS="-lreadline"
+	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_MACOSX -fno-common" SYSLIBS="-lreadline"

 mingw:
	$(MAKE) "LUA_A=lua53.dll" "LUA_T=lua.exe" \
