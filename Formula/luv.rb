class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/1.36.0-0.tar.gz"
  version "1.36.0-0"
  sha256 "739d733d32741a9e6caa3ff3a4416dcf121f39f622ee143c7d63130ce7de27be"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "luajit-openresty" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/keplerproject/lua-compat-5.3/archive/v0.10.tar.gz"
    sha256 "d1ed32f091856f6fffab06232da79c48b437afd4cd89e5c1fc85d7905b011430"
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3"

    args = std_cmake_args + %W[
      -DWITH_SHARED_LIBUV=ON
      -DWITH_LUA_ENGINE=LuaJIT
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}/deps/lua-compat-5.3
    ]

    system "cmake", ".", "-B", "build-module", *args
    cd "build-module" do
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end

    system "cmake", ".", "-B", "build-static", *args, "-DBUILD_MODULE=OFF", "-DBUILD_STATIC_LIBS=ON"
    cd "build-static" do
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    ENV["LUA_CPATH"] = lib/"lua/5.1/?.so"
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
    system "luajit", testpath/"test.lua"
  end
end
