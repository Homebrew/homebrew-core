class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.4.3.tar.gz"
  sha256 "f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb"
  license "MIT"

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7ba9cee9e5c01a0801a19226ba577ec2acf84244f7370c5de0f8ee7942948cd0"
    sha256 cellar: :any, big_sur:       "f7e0d6c4b3cd8d3fba1f26dd81d23eb68e1adfcd6f7915732449a8671eedfb1c"
    sha256 cellar: :any, catalina:      "7fa53bc358e3fc6ebd2e1bcc326cd13f18141d780d07daadcecb891ebe61aa94"
    sha256 cellar: :any, mojave:        "0196098bf8f4f49c78061412237acda0e2e2010f4abc61a7ac085ede71e9b7a3"
  end

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "readline"
  end

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/11c8360432f471f74a9b2d76e012e3b36f30b871/lua/lua-dylib.patch"
    sha256 "a39e2ae1066f680e5c8bf1749fe09b0e33a0215c31972b133a73d43b00bf29dc"
  end

  def install
    # Substitute formula prefix in `src/Makefile` for install name (dylib ID).
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.gsub! "@OPT_LIB@", opt_lib
      s.remove_make_var! "CC"
      s.change_make_var! "MYCFLAGS", ENV.cflags
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    system "make", "macosx", "INSTALL_TOP=#{prefix}"
    system "make", "install", "INSTALL_TOP=#{prefix}"
    (lib/"pkgconfig/lua.pc").write pc_file

    # Fix some software potentially hunting for different pc names.
    bin.install_symlink "lua" => "lua#{version.major_minor}"
    bin.install_symlink "lua" => "lua-#{version.major_minor}"
    bin.install_symlink "luac" => "luac#{version.major_minor}"
    bin.install_symlink "luac" => "luac-#{version.major_minor}"
    (include/"lua#{version.major_minor}").install_symlink Dir[include/"lua/*"]
    lib.install_symlink "liblua.#{version.major_minor}.dylib" => "liblua#{version.major_minor}.dylib"
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua#{version.major_minor}.pc"
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua-#{version.major_minor}.pc"
  end

  def pc_file
    <<~EOS
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
      Libs: -L${libdir} -llua -lm
      Cflags: -I${includedir}
    EOS
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
