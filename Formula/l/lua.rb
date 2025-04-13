class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.4.7.tar.gz"
  sha256 "9fbf5e28ef86c69858f6d3d34eccc32e911c1a28b4120ff3e84aaa70cfbf1e30"
  license "MIT"

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "925b155912162179d777cde03b60fdd8b5507f0bfc3c7adf2f7a49e1b3b00461"
    sha256 cellar: :any,                 arm64_sonoma:   "84862c80e0cba6ae50dc62a560bbff91a2607a2952d037da127588b5582bb272"
    sha256 cellar: :any,                 arm64_ventura:  "751b91605496a0ca76301b9dbfbdd151b6dd807dfd0acc3d517f631bf7dac110"
    sha256 cellar: :any,                 arm64_monterey: "9fa819a1bf2476966556690ca374e34543e33395af8147c7d9fc163bec02fc0b"
    sha256 cellar: :any,                 sonoma:         "e683482576a98b94e06c2049e874da06b2fe6a27fd6ad1076d280af7c8f9ad8d"
    sha256 cellar: :any,                 ventura:        "21f349c23444c0f74e7626e6837b4236f1617c3f0828157efe7438ed941cfb3d"
    sha256 cellar: :any,                 monterey:       "b3efe2d96158718df6a5255bf92e2809565cab7ede49d1631fa0247040fa148e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "542e289c463b5252729f03346724f17c1e22a4d34db457457075bb812ff6c284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e21c57b663809dfdbf18aa773bac852c0206c728e73daab48767c60bb8b1a7c"
  end

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "readline"
  end

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/11c8360432f471f74a9b2d76e012e3b36f30b871/lua/lua-dylib.patch"
      sha256 "a39e2ae1066f680e5c8bf1749fe09b0e33a0215c31972b133a73d43b00bf29dc"
    end

    # Add shared library for linux. Equivalent to the mac patch above.
    # Inspired from https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    on_linux do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0dcd11880c7d63eb395105a5cdddc1ca05b40f4a/lua/lua-so.patch"
      sha256 "522dc63a0c1d87bf127c992dfdf73a9267890fd01a5a17e2bcf06f7eb2782942"
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
