class LuaAT54 < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.4.8.tar.gz"
  sha256 "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae"
  license "MIT"
  compatibility_version 1

  # Check for new releases until https://www.lua.org/versions.html#5.4
  # says "There will be no further releases of Lua 5.4".
  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(5\.4(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03d6162ac99acbf2b668ebabea5bdd675bd1a0ec3ce202f915d0e9e017fb1af6"
    sha256 cellar: :any,                 arm64_sequoia: "374b0714ce6bf851fdf0d82ec0b203268c3fa4443108ad5aea6fface2466799f"
    sha256 cellar: :any,                 arm64_sonoma:  "b59c0bb19df706992a9216b20753a541ca5888b6b7a365129e5fa1e9d7282dfd"
    sha256 cellar: :any,                 sonoma:        "e3c4b81999ce73b9b4e0aa771e2deba2502fffe6f55d5f839d09fcd4ab912870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b16b4a9a0c052ea268f89aaa66c1e5d0b9e0b076c33cafd77a05c3c341332073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25322e8dcb660cd7fd50f3511acbacf9b63c5d4bb4ba68a9ebfcf3ddfabf600"
  end

  keg_only :versioned_formula

  on_linux do
    depends_on "readline"
  end

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/lua/lua-dylib.patch"
      sha256 "a39e2ae1066f680e5c8bf1749fe09b0e33a0215c31972b133a73d43b00bf29dc"
    end

    # Add shared library for linux. Equivalent to the mac patch above.
    # Inspired from https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    on_linux do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/lua/lua-so.patch"
      sha256 "522dc63a0c1d87bf127c992dfdf73a9267890fd01a5a17e2bcf06f7eb2782942"
    end
  end

  def install
    # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
    # when making a shared object; recompile with -fPIC
    # See https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    ENV.append_to_cflags "-fPIC" if OS.linux?

    # Substitute formula prefix in `src/Makefile` for install name (dylib ID).
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.gsub! "@OPT_LIB@", opt_lib if OS.mac?
      s.remove_make_var! "CC"
      s.change_make_var! "MYCFLAGS", ENV.cflags || ""
      s.change_make_var! "MYLDFLAGS", ENV.ldflags || ""
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    os = if OS.mac?
      "macosx"
    else
      "linux-readline"
    end

    system "make", os, "INSTALL_TOP=#{prefix}"
    system "make", "install", "INSTALL_TOP=#{prefix}"

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    libs = %w[-llua -lm]
    libs << "-ldl" if OS.linux?
    (lib/"pkgconfig/lua.pc").write <<~EOS
      V=#{version.major_minor}
      R=#{version}
      prefix=#{opt_prefix}
      INSTALL_BIN=${prefix}/bin
      INSTALL_INC=${prefix}/include/lua
      INSTALL_LIB=${prefix}/lib
      INSTALL_MAN=${prefix}/share/man/man1
      INSTALL_LMOD=${prefix}/share/lua/${V}
      INSTALL_CMOD=${prefix}/lib/lua/${V}
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
    assert_match "Homebrew is awesome!", shell_output("#{bin}/lua -e \"print ('Homebrew is awesome!')\"")
  end
end
