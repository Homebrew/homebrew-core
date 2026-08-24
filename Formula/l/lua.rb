class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.5.1.tar.gz"
  sha256 "1c4b4068d67061f2a2231ad2b5422e77acea1487ea9890f6320af614f4373dce"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "494c75d37ed889cd4deaf7cb40613e8ba2206b53af68a5ab3d47167c22138b50"
    sha256 cellar: :any, arm64_sequoia: "4dc6f450952c63886e1293adb7798fb8bfe9093c72400471ba160561affe6dc4"
    sha256 cellar: :any, arm64_sonoma:  "e102957f67a1fe9dc8bfd0d6409c4c776791daacb75f28910e28f0a13d1a438b"
    sha256 cellar: :any, sonoma:        "13ba70d9eeb49a39ed8d44b688f38cee7185bbe2ca88b400796a76a482833423"
    sha256 cellar: :any, arm64_linux:   "352ef08beb2cb7694bf37e7aa62152ea8b9d60172a7a65ff57c00c1c91dd53e9"
    sha256 cellar: :any, x86_64_linux:  "d221d3bf5b1ac55775e12cb147d995e6b29dc46a3e5dfc33bc3c6295fed1561e"
  end

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
  patch do
    file "Patches/lua/lua-shared.patch"
  end

  def install
    # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
    # when making a shared object; recompile with -fPIC
    # See https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    ENV.append_to_cflags "-fPIC" if OS.linux?

    # Substitute formula prefix in `src/Makefile` for install name (dylib ID) from our patch
    inreplace "src/Makefile", "@OPT_LIB@", opt_lib if OS.mac?

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    args = %W[
      CC=#{ENV.cc}
      INSTALL_INC=#{include}/lua
      INSTALL_MAN=#{man1}
      INSTALL_TOP=#{prefix}
      MYCFLAGS=#{ENV.cflags}
      MYLDFLAGS=#{ENV.ldflags}
      PLAT=#{OS.mac? ? "macosx" : "linux"}
    ]

    system "make", *args
    system "make", "install", *args
    lib.install Dir[shared_library("src/liblua", "*")]

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    libs = %w[-llua -lm]
    libs << "-ldl" if OS.linux?
    (lib/"pkgconfig/lua.pc").write <<~PC
      V=#{version.major_minor}
      R=#{version}

      prefix=#{versioned_formula? ? opt_prefix : HOMEBREW_PREFIX}
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
    PC

    # Fix some software potentially hunting for different pc names.
    bin.install_symlink "lua" => "lua#{version.major_minor}"
    bin.install_symlink "lua" => "lua-#{version.major_minor}"
    bin.install_symlink "luac" => "luac#{version.major_minor}"
    bin.install_symlink "luac" => "luac-#{version.major_minor}"
    (include/"lua#{version.major_minor}").install_symlink Dir[include/"lua/*"]
    lib.install_symlink shared_library("liblua", version.major_minor.to_s) => shared_library("liblua#{version.major_minor}")
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua#{version.major_minor}.pc"
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua-#{version.major_minor}.pc"
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
