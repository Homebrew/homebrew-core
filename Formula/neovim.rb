class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.3.2.tar.gz"
  sha256 "e34e56127c251112c07f5a9b10636ea27685ed468a66e4158ea0a0dda71ea5a3"
  head "https://github.com/neovim/neovim.git"

  bottle do
    sha256 "644a57613919724c94007adc28ed74f2fc2c5126497e7eeea5ba148e20789b0d" => :mojave
    sha256 "9826efa3522ce3b68f1944fc5da7d1cc3df30b219f4584a5c2eb6fd701841203" => :high_sierra
    sha256 "1e716173c8219e34ecc3d74f971f15d0c78f05421e94d8ec170346625d63a080" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "lua@5.1" => :build
  depends_on "luarocks" => :build
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

  resource "luabitop-rockspec" do
    url "https://luarocks.org/manifests/luarocks/luabitop-1.0.2-3.rockspec"
    sha256 "8cc12ebd2919b08765fef9f8738d2277204e8c6a7578e8e7f1abf6054380c21f"
  end

  resource "luabitop" do
    url "https://github.com/LuaDist/luabitop/archive/1.0.2.tar.gz"
    sha256 "d5f2ada780397e9bf8f885b811abdb4f86b7e7e7ee827e744efcf672882f4398"
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
    lua_path = "--lua-dir=#{Formula["lua@5.1"].opt_prefix}"

    cd "deps-build" do
      # penlight depends on luafilesystem
      cd "build/src/luafilesystem" do
        output = Utils.popen_read("luarocks", "unpack", lua_path, "luafilesystem-1.7.0-2.src.rock", "--tree=#{buildpath}/deps-build")
        unpack_dir = output.split("\n")[-2]
        cd unpack_dir do
          system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
        end
      end

      # busted depends on penlight
      cd "build/src/penlight" do
        system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
      end

      cp "build/src/luabitop-rockspec/luabitop-1.0.2-3.rockspec", "build/src/luabitop/"
      cd "build/src/luabitop/" do
        system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
      end

      %w[
        lpeg/lpeg-1.0.1-1.src.rock
        mpack/mpack-1.0.7-0.rockspec
        inspect/inspect-3.1.1-0.src.rock
        lua_cliargs/lua_cliargs-3.0-1.src.rock
        lua-term/lua-term-0.7-1.rockspec
        luasystem/luasystem-0.2.1-0.src.rock
        dkjson/dkjson-2.5-2.src.rock
        say/say-1.3-1.rockspec
        luassert/luassert-1.7.10-0.rockspec
        mediator_lua/mediator_lua-1.1.2-0.rockspec
        busted/busted-2.0.rc12-1.rockspec
        luacheck/luacheck-0.21.2-1.src.rock
        luv/luv-1.9.1-1.src.rock
        coxpcall/coxpcall-1.17.0-1.src.rock
        nvim-client/nvim-client-0.1.0-1.rockspec
      ].each do |rock|
        dir, rock = rock.split("/")
        cd "build/src/#{dir}" do
          output = Utils.popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{buildpath}/deps-build")
          unpack_dir = output.split("\n")[-2]
          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
          end
        end
      end

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
