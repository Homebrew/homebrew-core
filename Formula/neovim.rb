class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.3.1.tar.gz"
  sha256 "bc5e392d4c076407906ccecbc283e1a44b7832c2f486cad81aa04cc29973ad22"
  head "https://github.com/neovim/neovim.git"

  bottle do
    sha256 "9ef5628bc9bb852c21a9ab2933f1a9b2a0e8d328574281016037eb51e0af5b90" => :high_sierra
    sha256 "ba4a51a48aa0695b8e45372af868c4b32df2f8b7a0985b3684d242c07e6f0787" => :sierra
    sha256 "67cc861b34e6ce3174e9ecba04384d39f95ad052ca58d301866bb540fbce9fba" => :el_capitan
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

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.1-1.src.rock"
    sha256 "149be31e0155c4694f77ea7264d9b398dd134eca0d00ff03358d91a6cfb2ea9d"
  end

  resource "mpack" do
    url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.7/libmpack-lua-1.0.7.tar.gz"
    sha256 "68565484a3441d316bd51bed1cacd542b7f84b1ecfd37a8bd18dd0f1a20887e8"
  end

  resource "inspect" do
    url "https://luarocks.org/manifests/kikito/inspect-3.1.1-0.src.rock"
    sha256 "ea1f347663cebb523e88622b1d6fe38126c79436da4dbf442674208aa14a8f4c"
  end

  resource "luabitop" do
    url "https://luarocks.org/luabitop-1.0.2-1.src.rock"
    sha256 "fc7a8065a57462ee13bed7f95b0ab13f94ecd1bf846108c61ccf2c75548af26e"
  end

  resource "luafilesystem" do
    url "https://luarocks.org/luafilesystem-1.7.0-2.src.rock"
    sha256 "65e6d437e577a1d6cd509b6cd224d2cb9501d58d32a72cafbd4fd3f911681576"
  end

  resource "penlight" do
    url "https://stevedonovan.github.io/files/penlight-1.5.4.zip"
    sha256 "1855dca3c05b348034df6a8c8784c35a0209e12d21fc4b5c9db84d7383480e8d"
  end

  resource "lua_cliargs" do
    url "https://luarocks.org/lua_cliargs-3.0-1.src.rock"
    sha256 "d165b627b11dc83a11270d7d51760e5b714e3fd2388733c32af53e9b63bf27d4"
  end

  resource "lua-term" do
    url "https://github.com/hoelzro/lua-term/archive/0.07.tar.gz"
    sha256 "c1a1d0c57107147ea02878a50b768d1c3c13aca2769b026c5bb7a84119607f30"
  end

  resource "luasystem" do
    url "https://luarocks.org/luasystem-0.2.1-0.src.rock"
    sha256 "d1c706d48efc7279d33f5ea123acb4d27e2ee93e364bedbe07f2c9c8d0ad3d24"
  end

  resource "dkjson" do
    url "https://luarocks.org/dkjson-2.5-2.src.rock"
    sha256 "0391ebe73cfcee7d6b3d5dd5098e185c2103118e644688484beea665f15fc9e3"
  end

  resource "say" do
    url "https://github.com/Olivine-Labs/say/archive/v1.3-1.tar.gz"
    version "1.3-1"
    sha256 "23e8cd378bb4ab1693279100a785acb2246418e3570b7de7d995b5847b3507ca"
  end

  resource "luassert" do
    url "https://github.com/Olivine-Labs/luassert/archive/v1.7.10.tar.gz"
    sha256 "f9f8347727c2a4aa8af30d88a0de0314f04cd681b60430e24f6ec0ed393e12e1"
  end

  resource "mediator_lua" do
    url "https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz"
    version "1.1.2-0"
    sha256 "faf5859fd2081be4e9e4fb8873a2dc65f7eff3fd93d6dd14da65f8e123fcff9b"
  end

  resource "busted" do
    url "https://github.com/Olivine-Labs/busted/archive/v2.0.rc12-1.tar.gz"
    version "2.0.rc12-1"
    sha256 "c44286468babcc38e90f036d25471ab92f19a8a0a68482e0c45a9cfaeb1c0e35"
  end

  resource "luacheck" do
    url "https://luarocks.org/manifests/mpeterv/luacheck-0.21.2-1.src.rock"
    version "0.21.2-1"
    sha256 "c9e9b3bf1610e382043c6348417864541327108da92290a3be454c40be439953"
  end

  resource "luv" do
    url "https://luarocks.org/luv-1.9.1-1.src.rock"
    sha256 "d72db8321d8b3be925e1c14e6c13081466d1c31420f600154ab5c77fe6974fac"
  end

  resource "coxpcall" do
    url "https://luarocks.org/coxpcall-1.17.0-1.src.rock"
    version "1.17.0-1"
    sha256 "11feb07f08927c39b0b93e8c0bbaf15433f86155cba4820a31a09f4754ab3258"
  end

  resource "nvim-client" do
    url "https://github.com/neovim/lua-client/archive/0.1.0-1.tar.gz"
    version "0.1.0-1"
    sha256 "d2254c70eab7e7b6d7dc07caffe06f1015897fc09fdfa4b33f0b3745e6b0d03c"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"

    cd "deps-build" do
      system "luarocks-5.1", "build", "build/src/lpeg/lpeg-1.0.1-1.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/mpack/mpack-1.0.7-0.rockspec", "--tree=."
      system "luarocks-5.1", "build", "build/src/inspect/inspect-3.1.1-0.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/luabitop/luabitop-1.0.2-1.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/luafilesystem/luafilesystem-1.7.0-2.src.rock", "--tree=."
      cd "build/src/penlight" do
        system "luarocks-5.1", "make", "--tree=#{buildpath}/deps-build"
      end
      system "luarocks-5.1", "build", "build/src/lua_cliargs/lua_cliargs-3.0-1.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/lua-term/lua-term-0.7-1.rockspec", "--tree=."
      system "luarocks-5.1", "build", "build/src/luasystem/luasystem-0.2.1-0.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/dkjson/dkjson-2.5-2.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/say/say-1.3-1.rockspec", "--tree=."
      system "luarocks-5.1", "build", "build/src/luassert/luassert-1.7.10-0.rockspec", "--tree=."
      system "luarocks-5.1", "build", "build/src/mediator_lua/mediator_lua-1.1.2-0.rockspec", "--tree=."
      system "luarocks-5.1", "build", "build/src/busted/busted-2.0.rc12-1.rockspec", "--tree=."
      system "luarocks-5.1", "build", "build/src/luacheck/luacheck-0.21.2-1.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/luv/luv-1.9.1-1.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/coxpcall/coxpcall-1.17.0-1.src.rock", "--tree=."
      system "luarocks-5.1", "build", "build/src/nvim-client/nvim-client-0.1.0-1.rockspec", "--tree=."
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
