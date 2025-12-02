class Lpeg < Formula
  desc "Parsing Expression Grammars For Lua"
  homepage "https://www.inf.puc-rio.br/~roberto/lpeg/"
  url "https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz"
  mirror "https://github.com/neovim/deps/raw/master/opt/lpeg-1.1.0.tar.gz"
  sha256 "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?lpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "23fa0a2aba7c78631a3a0116d17f97998069884af257cd741e08da9097802d65"
    sha256 cellar: :any,                 arm64_sequoia:  "af50e5ff5ff953cb182ffb7657fdbf5fbfc9958f12be114c6713d7e62190c421"
    sha256 cellar: :any,                 arm64_sonoma:   "d725e7feeb5c96970d64781282c5c4ae56e9e1b2e824280c9ac2d4098acd18cb"
    sha256 cellar: :any,                 arm64_ventura:  "032f19654879a0542eb5836fa19da7ae278fb1709375f4b17e8a24b219e54293"
    sha256 cellar: :any,                 arm64_monterey: "d9b65ef2160677f986634fb433681bab43f7f87d2510884e373dab0d7bbd86a2"
    sha256 cellar: :any,                 arm64_big_sur:  "940a61e43f0f916e029a4afa277f55f95f2d780a5e88cbb255d9d7ca24d3a25d"
    sha256 cellar: :any,                 sonoma:         "8d5ac91544867d83ce0ec6f407e6a3ead572ccbd523234d2673322da355435fb"
    sha256 cellar: :any,                 ventura:        "0bd6d115782c46c0a09e07a4d27429211bef1a251ceb8d33f14a5530ce530c9e"
    sha256 cellar: :any,                 monterey:       "66c950f321432b109386fa6182bdfe6afb26d59f38d2d70e3d1087f5cf1637ed"
    sha256 cellar: :any,                 big_sur:        "cb3e28c5aacd7007606fedac99181a819081e5bb80fe2eee6689b6a30dc1768b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e53aaa71544d8b622b5de93bc94ec6df302180ff3c89df5f25ddc5fc8da75dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9143038c664866b58c882ed78450fc005c6169d32d9bf2ded09f2af664b3c4"
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
    # Needed by neovim.
    lib.install_symlink lib/"lua/5.1/lpeg.so" => shared_library("liblpeg")
  end

  test do
    system "lua", pkgshare/"test.lua"
    system "luajit", pkgshare/"test.lua"
  end
end
