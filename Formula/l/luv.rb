class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/1.51.0-2.tar.gz"
  sha256 "d70cf20b16ab05ceaa3bb448f3e1b3ef63a5949e34184255c52a3e92efcd39b4"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a8f77a081d0976eea4b61cc72a9bcec9c913f2d76c5933632e840602cad5f6b"
    sha256 cellar: :any,                 arm64_sequoia: "f06d42943074e293060d972e368c692d5ac9ce3f0da5de641ad0f148c5fe057a"
    sha256 cellar: :any,                 arm64_sonoma:  "db52f0890b575e7926f7875c33853691b05e6655022d0b32bdb0866de4ecaaff"
    sha256 cellar: :any,                 sonoma:        "88d513ccb8ee6b33f4e2420ba9c331fb4bec78e9e181bfc5ca12979ef323db8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d748e16e1eed08fc90b00324a0da9ce3b639946b5d922eabd9c28df3b8be16e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e36a6b3522e93573456d0c5a224dccee69855281bc8d131ed1bf5e18b088a753"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.14.4.tar.gz"
    sha256 "a9afa2eb812996039a05c5101067e6a31af9a75eded998937a1ce814afe1b150"
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3" if build.stable?

    args = %W[
      -DWITH_SHARED_LIBUV=ON
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}/deps/lua-compat-5.3
      -DBUILD_MODULE=ON
    ]

    system "cmake", "-S", ".", "-B", "buildjit",
                    "-DWITH_LUA_ENGINE=LuaJIT",
                    "-DBUILD_STATIC_LIBS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildjit"
    system "cmake", "--install", "buildjit"

    system "cmake", "-S", ".", "-B", "buildlua",
                    "-DWITH_LUA_ENGINE=Lua",
                    "-DBUILD_STATIC_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildlua"
    system "cmake", "--install", "buildlua"
  end

  test do
    (testpath/"test.lua").write <<~LUA
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    LUA

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("lua test.lua")
  end
end
