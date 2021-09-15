class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.41.1-0.tar.gz"
  sha256 "24773c53fbc4f68cdeb25c62cf4df7601097bfc08b3918ab269065564a845813"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b4c1ef78ea2dc05143c8bfa0a3bfa3f7bd001e41e0e1b4dc3037c346efd3bea4"
    sha256 cellar: :any,                 big_sur:       "93fa7141185155c4e256a0af9551e376050e88bd8a0267d8e4f110a2fd16892c"
    sha256 cellar: :any,                 catalina:      "567973b62f5dfb823e58d976607d09363b76a32e46ad85d438c07dcc97ac894b"
    sha256 cellar: :any,                 mojave:        "207883cb6e73602a36fb7df9c67e7e41f470ceeb8d3c5d8de5ec555b4e238867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601206ff9acb80a3829baa5ea20e0ed001b854516187524439ef52e004fe4d03"
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
