class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.42.0-0.tar.gz"
  sha256 "8caee38de2fba0da32abbe96f55244e4a2c67d6cdde161a1935af94bffd5470f"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0f12b7109db61ed5b8277dbdc7a0720ca2ae5605c4fd78b86164ddeaf62e9264"
    sha256 cellar: :any,                 big_sur:       "b54904cab847bb6fe8ddf6b9d8cc8aff79339c89f4cd5986d0ccf9dc52a1754c"
    sha256 cellar: :any,                 catalina:      "2741dd32a1eb404de14e58395e2eed255307f456498cfd5391635de964268cd4"
    sha256 cellar: :any,                 mojave:        "bd07948d9f6c3af48b153c591c206553a36242a428ba675ce7fe3e2d635d1f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368050bf1c69408ab73970e90d7024d427c0192ba0978b48c6f97b4bf4a5e1da"
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
