class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.44.2-0.tar.gz"
  sha256 "44ccda27035bfe683e6325a2a93f2c254be1eb76bde6efc2bd37c56a7af7b00a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6649f9cf388d3247f1a1fad0b36a27712b1a6f957c7de650452bc08f067bb43c"
    sha256 cellar: :any,                 arm64_big_sur:  "cab0b66ac788ce3e35d2e1206962cf6697b91252e104d736b628408b20a2ffcd"
    sha256 cellar: :any,                 monterey:       "b7b651df09aef8b9c92defa233facb7c2c7ca717e6b0df5d43055d3d0bf1b999"
    sha256 cellar: :any,                 big_sur:        "02bb94d8c10f2b76d60f38c1568be31263d1a2572f0efef9199c27d5a6fdcc8d"
    sha256 cellar: :any,                 catalina:       "5b7d1d428cdbe4fd9a285cae45b2bce3d70a2f292557f6dd9101355241a7ab87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b17d98ac5b4194fdb9aa6851c90a311e8b14b0412b679d231e6b172d45426e"
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
