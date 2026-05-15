class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.5.0.tar.gz"
  sha256 "57ccc32bbbd005cab75bcc52444052535af691789dba2b9016d5c50640d68b3d"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49abafdff9b515d4efaf88f0924674d9bf904a12994d61ee097b895a6acc995e"
    sha256 cellar: :any,                 arm64_sequoia: "4edd2e3cca37fbcb60899a874e6c6c8ab109b8fa1799b0cf74b4a13f05ac343d"
    sha256 cellar: :any,                 arm64_sonoma:  "d4b0fa4b6d251461813ba23f12b119a3d4aa34f7b9f10557d8ed8d70eeebb85a"
    sha256 cellar: :any,                 sonoma:        "0372a23d7fee9f77f4ec713ad066c9fbb2164571d030e542f196b61fd01ee680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71736bbe1a40c02aa07b2588e4b71e2604d707af3327b0e6c2cd9dbcaa8b2f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2df2766da50231d52b6f0a24ac465843153bb387c696804548726478217684ea"
  end

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/cd752b79c8dc7106cef6c95404308c1b1c400770/Patches/lua/lua-shared.patch"
    sha256 "7774de7be06126805f189d321bcee595a676858c52d26f6777c79f5c1d789975"
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
    (lib/"pkgconfig/lua.pc").write <<~EOS
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
