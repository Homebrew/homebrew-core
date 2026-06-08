class Lpeg < Formula
  desc "Parsing Expression Grammars For Lua"
  homepage "https://www.inf.puc-rio.br/~roberto/lpeg/"
  url "https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz"
  mirror "https://github.com/neovim/deps/raw/master/opt/lpeg-1.1.0.tar.gz"
  sha256 "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a"
  license "MIT"
  revision 2
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?lpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3ef5600e2a654aea26c48469ab8ffee9fe117c71fe4d617646939b0f74059bd"
    sha256 cellar: :any,                 arm64_sequoia: "afeb8aa90c0d61871094edc33f8992b478791bb24bbe07ddfe45b3e0da38e118"
    sha256 cellar: :any,                 arm64_sonoma:  "2465c478129b2ccf00900021b54204d79145e8124d75c55ee3dea9d0a56f41f1"
    sha256 cellar: :any,                 sonoma:        "973868eaace571f6f1c7764cf02a41f7fdd20b59b01d380f2905e76de06e439e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "658195428657fbe6cbf45c95ab2e69dd416767ddbe6c02593a03984d1efcffdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9087115cb278f1b318ca5334804948f0a44c7983d36acb0b5b171b12bd97df3f"
  end

  depends_on "lua" => [:build, :test]
  depends_on "lua@5.4" => [:build, :test] # TODO: remove once no dependents need Lua 5.4
  depends_on "luajit" => [:build, :test]

  def make_install_lpeg_so(luadir, dllflags, abi_version)
    system "make", "LUADIR=#{luadir}", "DLLFLAGS=#{dllflags.join(" ")}", "lpeg.so"
    (share/"lua"/abi_version).install_symlink pkgshare/"re.lua"
    (lib/"lua"/abi_version).install "lpeg.so"
    system "make", "clean"
  end

  def luas
    deps.map(&:to_formula).select { |f| f.name.match?(/^lua(@\d+(\.\d+)*)?$/) }
  end

  def luajit = Formula["luajit"]

  def install
    dllflags = %w[-shared -fPIC]
    dllflags << "-Wl,-undefined,dynamic_lookup" if OS.mac?

    make_install_lpeg_so(luajit.opt_include/"luajit-2.1", dllflags, "5.1")
    luas.each do |lua|
      make_install_lpeg_so(lua.opt_include/"lua", dllflags, lua.version.major_minor)
    end

    doc.install "lpeg.html", "re.html"
    pkgshare.install "test.lua", "re.lua"
    # Needed by neovim.
    lib.install_symlink lib/"lua/5.1/lpeg.so" => shared_library("liblpeg")
  end

  test do
    luas.each do |lua|
      system lua.bin/"lua", pkgshare/"test.lua"
    end
    system luajit.bin/"luajit", pkgshare/"test.lua"
  end
end
