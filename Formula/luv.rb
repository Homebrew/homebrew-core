class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.41.0-0.tar.gz"
  version "1.41.0-0"
  sha256 "e8bf76a4d6bdfbce4230988c4b4b38e5423a28ca9af40dcbb1e5761c312e3d9a"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3a2b1d72d8a9b96f27d3f556adc604a154752e42fbbb564d90d24b30c900e0ff"
    sha256 cellar: :any, big_sur:       "22842418ed0fbb51f839c433fa895eb1309ca8870dedefeeffd6442d702c5335"
    sha256 cellar: :any, catalina:      "2e5b7272fc97e1217b5abc250fb8fb955aeef189f2ae551b72bf29991dafe0ba"
    sha256 cellar: :any, mojave:        "aca7ac35af4e7a4362c05f0816923113f977b0916b63a5b6ec330fc67d450d86"
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
