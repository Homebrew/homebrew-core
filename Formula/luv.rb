class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  version "1.36.0-0"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/luvit/luv/archive/1.36.0-0.tar.gz"
    sha256 "739d733d32741a9e6caa3ff3a4416dcf121f39f622ee143c7d63130ce7de27be"

    resource "lua-compat-5.3" do
      url "https://github.com/keplerproject/lua-compat-5.3/archive/v0.10.tar.gz"
      sha256 "d1ed32f091856f6fffab06232da79c48b437afd4cd89e5c1fc85d7905b011430"
    end

    # Patch to fix shared library build failure on macOS. Remove at next release.
    # https://github.com/luvit/luv/pull/533
    patch do
      url "https://github.com/luvit/luv/commit/10a27c2b58cb6c2338223b70382397be508cdc86.patch?full_index=1"
      sha256 "793ada6b314f5c6bc308a0ff7d1713632c75d641578455a6570e7bf4a4187e4d"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f6206cb6d576a9d76340207c9bb0ea606fa436396e8e6f47c8f112cb5ff30b9a"
    sha256 cellar: :any, big_sur:       "7c8d417a89cd453f5a10beedf86a79a48280289fea2992677c6cf299f62dff5c"
    sha256 cellar: :any, catalina:      "8916140ae938a0094f5633e9d2822824f94463c70d8b9c7212b61d8813c48021"
    sha256 cellar: :any, mojave:        "5fad043a019896b644261362348caf757e256890c46fc4e268ad79710d45b57b"
  end

  head do
    url "https://github.com/luvit/luv.git"

    resource "lua-compat-5.3" do
      url "https://github.com/keplerproject/lua-compat-5.3.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "luajit-openresty" => [:build, :test]
  depends_on "libuv"

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3"

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
