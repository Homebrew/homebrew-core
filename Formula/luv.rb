class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.44.2-0.tar.gz"
  sha256 "44ccda27035bfe683e6325a2a93f2c254be1eb76bde6efc2bd37c56a7af7b00a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "385f3c3f6d508c1624e98621b6fd03a717dcfd97fdc74a3a0fea2fd23587286a"
    sha256 cellar: :any,                 arm64_big_sur:  "7242559d60b04067a7585740803d13c08e537ddd18d1f36b4310ed802541cfba"
    sha256 cellar: :any,                 monterey:       "eeae4eb239fa90e64852b43760c1a87a34ac5fdeeb10e165101118c17a60963c"
    sha256 cellar: :any,                 big_sur:        "6806df1f22b4cf8ac87918fc791c11e986df57149238b1a51a46a55f4b1796ef"
    sha256 cellar: :any,                 catalina:       "21f7c62b5d0e94d443de4362d0aa22424e937cb43ebfe26820d9e3190a11b890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d9d0111b1d86b1bf4908c24555d859ab11587e65999a3ecea6f9d2c9424c01e"
  end

  depends_on "cmake" => :build
  depends_on "luajit" => [:build, :test]
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
