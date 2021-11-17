class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.4.3.tar.gz"
  sha256 "f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb"
  license "MIT"
  revision 1

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d0ac5ebb4064dea9bb4afa547eb634f16ceed7662c653c3a9c24d28c4a2b75ec"
    sha256 cellar: :any,                 arm64_big_sur:  "d0137a42c7c544f32393f4673d205f9dbfb5afbf50051cb78424810808e10cde"
    sha256 cellar: :any,                 monterey:       "918a63c8c529672f227327e3f4a747e04df918f2a5e5c37adffd911183fb7205"
    sha256 cellar: :any,                 big_sur:        "03e5112423f6542a6951e1fbd748150f1d8e6bdeaadd02a3ad14c7579503e26c"
    sha256 cellar: :any,                 catalina:       "723d8fe07a4c9f430ecf3d26d56aeba31112f3d908b5cf9a69ad57ca66fa80f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a74b17d1390fc31bd922c5fea400b5480e59d4048d5c3281bf2bd5013b8ef947"
  end

  uses_from_macos "unzip" => :build

  on_macos do
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/11c8360432f471f74a9b2d76e012e3b36f30b871/lua/lua-dylib.patch"
      sha256 "a39e2ae1066f680e5c8bf1749fe09b0e33a0215c31972b133a73d43b00bf29dc"
    end
  end

  on_linux do
    depends_on "readline"

    # Add shared library for linux. Equivalent to the mac patch above.
    # Inspired from http://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0dcd11880c7d63eb395105a5cdddc1ca05b40f4a/lua/lua-so.patch"
      sha256 "522dc63a0c1d87bf127c992dfdf73a9267890fd01a5a17e2bcf06f7eb2782942"
    end
  end

  def install
    if OS.linux?
      # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
      # when making a shared object; recompile with -fPIC
      # See http://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
      ENV.append_to_cflags "-fPIC"
    end

    # Substitute formula prefix in `src/Makefile` for install name (dylib ID).
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.gsub! "@OPT_LIB@", opt_lib if OS.mac?
      s.remove_make_var! "CC"
      s.change_make_var! "MYCFLAGS", ENV.cflags
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
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
      V= #{version.major_minor}
      R= #{version}
      prefix=#{HOMEBREW_PREFIX}
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
    lib.install_symlink shared_library("liblua", version.major_minor) => shared_library("liblua#{version.major_minor}")
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
