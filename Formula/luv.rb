class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.44.2-1.tar.gz"
  sha256 "f8c69908e17ec8ab370253d1508e23deaecfc0c4752d2efb77e427e579501104"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "769a34818f15194c233183046646e3881e3626ca82bee92117c46e61b3a98e22"
    sha256 cellar: :any,                 arm64_big_sur:  "e9fda6e3530e971e96fbc3458418c9a2f2c125c8450e1853bf633c691d4d1865"
    sha256 cellar: :any,                 monterey:       "c8e50d366b41546c45179a058269feb68bc207ec90133e4dd788f365cfa6b76b"
    sha256 cellar: :any,                 big_sur:        "08a838d498a73ce82ac070ee30233a0e975357b0eeec641fbae707e78f7cf106"
    sha256 cellar: :any,                 catalina:       "9f665a63fafd76131c8bb7bd99307f577f1c7798b4e56bf52f18238fa27e8373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b5c519b4d10229b6e69fcff9ad59bf89618d7da14eea0935b900d4623ae2739"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/keplerproject/lua-compat-5.3/archive/v0.10.tar.gz"
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
