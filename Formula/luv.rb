class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.43.0-0.tar.gz"
  sha256 "a36865f34db029e2caa01245a41341a067038c09e94459b50db1346d9fdf82f0"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b4529c59f0e8f58f507bd11e5d8967578714314a087c0785258acde0be0bef3c"
    sha256 cellar: :any,                 arm64_big_sur:  "0fcb0c6d13ac07df04e17a333ef7ac8b7d31deff84b704b3ef0c460c71e8820a"
    sha256 cellar: :any,                 monterey:       "a89289ec8dae280bc34f0a3e1e2a64a02b121f008d649bfd9eac4482845a5bc9"
    sha256 cellar: :any,                 big_sur:        "96f504631a2d774ddc620ce51c629df26bed837bb6f2c05bd5c57c8449a4417d"
    sha256 cellar: :any,                 catalina:       "93af33e578778e57173481255a4da1cd04994a358220545484a295d798928a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4123f80ab177e7d5346b2d045f76c6a8dc7ae052fddbdfc0d5208bf0b50f1d43"
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
