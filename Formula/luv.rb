class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.42.0-1.tar.gz"
  sha256 "a55563e6da9294ea26f77a2111598aa49188c5806b8bd1e1f4bdf402f340713e"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b40a0433f4f7dbbb321d83600456394491c305a5faefa43626c94751d121db1"
    sha256 cellar: :any,                 arm64_big_sur:  "138d35727357922de60de5e5f3bbfc61eb3d8d31bf2389776b65218fdf2eacb0"
    sha256 cellar: :any,                 monterey:       "08db7612d37222c7447e9cc6364679d4247dda77dad00937df30d9ace3bc9643"
    sha256 cellar: :any,                 big_sur:        "dabce5b68101043976dac8678d416ff9411a48c39d3f2148295aa3125f5f9b99"
    sha256 cellar: :any,                 catalina:       "546d125b85b7a5b92fe133f11eb31063b5e035936ef8135cad6b27328f23f2fb"
    sha256 cellar: :any,                 mojave:         "8c7f6541f39122b5183c218308b5300558eeffeb88b36bf0def29d1ef99d968e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d3f068a51e7744d6553114d0aa24c6a0b8332aa9f5c746a27ed4f2b1015609"
  end

  depends_on "cmake" => :build
  depends_on "luajit-openresty" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/keplerproject/lua-compat-5.3/archive/v0.10.tar.gz"
    sha256 "d1ed32f091856f6fffab06232da79c48b437afd4cd89e5c1fc85d7905b011430"
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3" unless build.head?

    args = std_cmake_args + %W[
      -DWITH_SHARED_LIBUV=ON
      -DWITH_LUA_ENGINE=LuaJIT
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}/deps/lua-compat-5.3
      -DBUILD_MODULE=ON
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_STATIC_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["LUA_CPATH"] = opt_lib/"lua/5.1/?.so"
    ENV.prepend_path "PATH", Formula["luajit-openresty"].opt_bin
    (testpath/"test.lua").write <<~EOS
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    EOS
    assert_equal "Sleeping\nAwake!\n", shell_output("luajit test.lua")
  end
end
