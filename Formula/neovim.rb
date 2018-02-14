class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.2.2.tar.gz"
  sha256 "a838ee07cc9a2ef8ade1b31a2a4f2d5e9339e244ade68e64556c1f4b40ccc5ed"
  revision 1
  head "https://github.com/neovim/neovim.git"

  bottle do
    sha256 "86b8181d2d6c96a6ecbac8414087456631cabdb27e6d36fee9f2e9c723fe99ad" => :high_sierra
    sha256 "c2e551578f36847121dd8cdcdfd3de9abf5836906658e166ab6e5d71ba805de5" => :sierra
    sha256 "4e193b9c000868ece51cd256fb9831423381969fbc53212f18484b5b2cba187a" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "lua@5.1" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "jemalloc"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit"
  depends_on "msgpack"
  depends_on "unibilium"
  depends_on "python" if MacOS.version <= :snow_leopard

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.1-1.src.rock", :using => :nounzip
    sha256 "149be31e0155c4694f77ea7264d9b398dd134eca0d00ff03358d91a6cfb2ea9d"
  end

  resource "mpack" do
    url "https://luarocks.org/manifests/tarruda/mpack-1.0.6-0.src.rock", :using => :nounzip
    sha256 "9068d9d3f407c72a7ea18bc270b0fa90aad60a2f3099fa23d5902dd71ea4cd5f"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"

    cd "deps-build" do
      system "luarocks-5.1", "build", "build/src/lpeg/lpeg-1.0.1-1.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/mpack/mpack-1.0.6-0.src.rock", "--tree=."
      system "cmake", "../third-party", "-DUSE_BUNDLED=OFF", *std_cmake_args
      system "make"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end
