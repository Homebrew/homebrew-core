class Lpeg < Formula
  desc "Parsing Expression Grammars For Lua"
  homepage "https://www.inf.puc-rio.br/~roberto/lpeg/"
  url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz"
  mirror "https://github.com/neovim/deps/raw/master/opt/lpeg-1.1.0.tar.gz"
  sha256 "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?lpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c1682de26518f02988af37b26b82436735887d9e706a492470912d4d7d3bcf32"
    sha256 cellar: :any,                 arm64_monterey: "85261557c9e28bcc69e57a039dc37f041822ad173b12ed8929ccf3b188792a45"
    sha256 cellar: :any,                 arm64_big_sur:  "cacf451975f7154a73f943d3cf875547b3adcae9142f8b7edf305158f2ddeb25"
    sha256 cellar: :any,                 ventura:        "29f514322b45fc9cbca0e56d3c04b3e99acd493adabd124658e023aa8fd04b94"
    sha256 cellar: :any,                 monterey:       "515b7651928ec35f3f794f9d43a3a77b991e65f57b1c9f0541babec684f90c82"
    sha256 cellar: :any,                 big_sur:        "ba9d20b0c8e3c8310ab8b8ad6f62ac7b55a03050afa037257823962a84a40c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72cc4cc5e772e414daf6ca8dea191184c659eb6bd050bf42da5e100807b53d69"
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
