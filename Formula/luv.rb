class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.44.2-1.tar.gz"
  sha256 "f8c69908e17ec8ab370253d1508e23deaecfc0c4752d2efb77e427e579501104"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7c8432625ecd382168eac3d0bc3615519528a8e338f8f33ee0c6761bf9f5dd65"
    sha256 cellar: :any,                 arm64_monterey: "1d5aaf149019d3d775b093efaa51fda452248eccf109e961325d0a8de917f947"
    sha256 cellar: :any,                 arm64_big_sur:  "ce3cf05ca363a0978151a8f1ae096bb1d13d26718d2dfc25c3618e6156a4f6e2"
    sha256 cellar: :any,                 ventura:        "f3b9a7e332ee5024fcac9edc7ca8a9a17811033d3c0cf7f972bb6252bd6d7051"
    sha256 cellar: :any,                 monterey:       "1644986934f6275f3f7f632e074cdc9866ad3c2b83661035cd99f5f7912831c9"
    sha256 cellar: :any,                 big_sur:        "4c93fce6a32d76a35e365d1fb23b08c3bcfaf0de2426f8490d38128c9d2d8781"
    sha256 cellar: :any,                 catalina:       "c2d5d6718df8309860cd392047a071770d3c298f29a441f4639d47d909cd873a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c1bd86d334299bd8b6af4f0d4080f2b5dab6033778e65a90424be090f10374b"
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
