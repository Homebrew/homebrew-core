class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  revision 1

  stable do
    url "https://github.com/neovim/neovim/archive/v0.2.0.tar.gz"
    sha256 "72e263f9d23fe60403d53a52d4c95026b0be428c1b9c02b80ab55166ea3f62b5"

    depends_on "luajit" => :build

    # Remove for > 0.2.0
    # Upstream commit from 7 Jul 2017 "Prefer the static jemalloc library by default on OSX"
    # See https://github.com/neovim/neovim/pull/6979
    patch do
      url "https://github.com/neovim/neovim/commit/35fad15c8907f741ce21779393e4377de753e4f9.patch?full_index=1"
      sha256 "b156fdc92a3850eca3047620087f25a021800b729a3c30fd0164404b2ff7848b"
    end
  end

  bottle do
    sha256 "6d0cbbaadd947b428f29fb28ba0f492f2d84a71d981ad22cf00032036118ddf9" => :sierra
    sha256 "fdb74c70048d2c9232525ab652464d9818d0134442c855168f399ab2dd9504a7" => :el_capitan
    sha256 "f563c067954a4c5f98ad2b01ee3219e5d1666f7000917474186127122cf5cc76" => :yosemite
  end

  head do
    url "https://github.com/neovim/neovim.git"

    depends_on "luajit"
  end

  depends_on "cmake" => :build
  depends_on "lua@5.1" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "jemalloc"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "msgpack"
  depends_on "unibilium"
  depends_on :python if MacOS.version <= :snow_leopard

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
