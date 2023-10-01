class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.45.0-0.tar.gz"
  sha256 "97e89940f9eeaa8dfb34f1c19f80dd373299c42719d15228ec790f415d4e4965"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5661f1ffa089435dd176fc95d245d425f6722d198f3a0fa5223735117b85fc5"
    sha256 cellar: :any,                 arm64_ventura:  "bc38c2dbc804c17b0a4896f4723ded25e18c2a935363ecb65d1a28c6382442d6"
    sha256 cellar: :any,                 arm64_monterey: "7835da93f476691806ff0417a9ff5a7406843f0e4137b8dec0a764931108cfa6"
    sha256 cellar: :any,                 arm64_big_sur:  "7cccaa909a9ecfbac491aaa0fc00d294d46d6fd3eea6b789e3dc607e73abb09f"
    sha256 cellar: :any,                 sonoma:         "9b514ba45ccab03847e7dee71e0e4d123b8ed465d2922ea8cab192154194a4a1"
    sha256 cellar: :any,                 ventura:        "c00db5a8ec11d0c36eb1052da3f44959f0f14378bb2a0737decbc4d400ba8da0"
    sha256 cellar: :any,                 monterey:       "801b05eb51a0a988a21233a0230fa21ff135255e8253cf07e6aa5a08c5719424"
    sha256 cellar: :any,                 big_sur:        "fb2f8280793423f81065a62eec51b377062e8f50d1ffbdcd468150be632a80d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32cc9dc86b05ccb035107f6836a9c7374792c4a1a2438eab15f104d9626b3a73"
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
