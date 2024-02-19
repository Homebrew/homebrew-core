class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/1.47.0-0.tar.gz"
  sha256 "f9911d9d33808514e9ddc1e74667a57c427efa14fefecfa5fabe80ce95a3150a"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6542aa54d40207a854d146f8f80eaa12395c8510ab9810cd7eeb182024ce45a0"
    sha256 cellar: :any,                 arm64_ventura:  "bf086582a791396d25ef1c6af8f6cc795c708f1588767a9a988a2744cef442bc"
    sha256 cellar: :any,                 arm64_monterey: "5d0585fef34febe2e6eaf877ba99359cc30bfe5040d51c25cee95259af85e0a9"
    sha256 cellar: :any,                 sonoma:         "4b74da98648b146f33eac044ccecc8fc8098f354f80460e1261f64d9f83679d8"
    sha256 cellar: :any,                 ventura:        "c50b9e334980f1fd8ecea1868a4972aa6cbffa484cfe59bea50f0d94377bf5d2"
    sha256 cellar: :any,                 monterey:       "7ee200bb6e1a39e5d9ff52e7950359beb803feb4637252c188700c6501ca892b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d189e1d69c4b9797d12b8781326484dc304011abf94b6953449c4e21664799a6"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/keplerproject/lua-compat-5.3/archive/refs/tags/v0.10.tar.gz"
    sha256 "d1ed32f091856f6fffab06232da79c48b437afd4cd89e5c1fc85d7905b011430"
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3" unless build.head?

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

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("lua test.lua")
  end
end
