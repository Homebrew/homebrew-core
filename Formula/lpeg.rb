class Lpeg < Formula
  desc "Parsing Expression Grammars For Lua"
  homepage "https://www.inf.puc-rio.br/~roberto/lpeg/"
  url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz"
  mirror "https://github.com/neovim/deps/raw/master/opt/lpeg-1.0.2.tar.gz"
  sha256 "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?lpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "282c9c955bae5e974497dade90f5672109e5675fa3a1f0fc1f8f3f7ac21eb784"
    sha256 cellar: :any,                 arm64_monterey: "af85bc4d6170db54d20760fc9f04a9aac6a178d78373e861f8ad1fcb6f17288d"
    sha256 cellar: :any,                 arm64_big_sur:  "a61a8c4a5c6c0eb71bfe6bca496b0d3a53caab80ff67402973fff7736f4b65e5"
    sha256 cellar: :any,                 ventura:        "d2c938cf8932c1d631515f8b47e96477391caf5712566c113d7b3f59efc6c81e"
    sha256 cellar: :any,                 monterey:       "cfcd6d7c3ed399f591e3a2f27812a712b56ad5763c9896805eae1c1919f5e97c"
    sha256 cellar: :any,                 big_sur:        "9b0c78d78808cd381d5cf3124d2587ce297e998122e61e118397603c2b151ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f772ba0aa45c832c10465a8012b47bdbd43beda1f2121f8b939802ecca030d"
  end

  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]

  def make_install_lpeg_so(luadir, dllflags, abi_version)
    system "make", "LUADIR=#{luadir}", "DLLFLAGS=#{dllflags.join(" ")}", "lpeg.so"
    (share/"lua"/abi_version).install_symlink pkgshare/"re.lua"
    (lib/"lua"/abi_version).install "lpeg.so"
    system "make", "clean"
  end

  def install
    dllflags = %w[-shared -fPIC]
    dllflags << "-Wl,-undefined,dynamic_lookup" if OS.mac?

    luajit = Formula["luajit"]
    lua = Formula["lua"]

    make_install_lpeg_so(luajit.opt_include/"luajit-2.1", dllflags, "5.1")
    make_install_lpeg_so(lua.opt_include/"lua", dllflags, lua.version.major_minor)

    doc.install "lpeg.html", "re.html"
    pkgshare.install "test.lua", "re.lua"
  end

  test do
    system "lua", pkgshare/"test.lua"
    system "luajit", pkgshare/"test.lua"
  end
end
