class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/v1.50.0-0.tar.gz"
  sha256 "9d56b793138a2e7dbf53148740a3ee4777d2d51842d175ba85fa907d71f079dc"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9aa88f6497caef7418024eb961a30f5bb5db097d2e1af90ef79939a15b8140f6"
    sha256 cellar: :any,                 arm64_sonoma:  "0f83dcb1ff76d6e3a4c0cc4d4dff46fab4bc22b64e268ba6bfcebd7aedefbf48"
    sha256 cellar: :any,                 arm64_ventura: "ec0979b54e5fd5471582f53d9c45003181fdd1f7f1865a3a90698839ffef729a"
    sha256 cellar: :any,                 sonoma:        "29aa7d58757c2219fc4f5a80ee7b9626e24830536ee03fa44a50da5a19b16c4a"
    sha256 cellar: :any,                 ventura:       "43e34238e63cfd0d5f5dfce09a52a31d59b06751e0eb07cc9439a223e30634b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dffec8b9bf27ef16fd38a28cf73b076044ce6451085eda4e82663f965b5f8687"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.14.3.tar.gz"
    sha256 "db8ffa2c5562fac4fce5e5f48fd25763e79190af5e3d3d91f0699e4711cfbf10"
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
