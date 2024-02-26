class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/v1.48.0-0.tar.gz"
  sha256 "c9c12e414f8045aea11e5dbb44cd6c68196c10e02e1294dad971c367976cc1f9"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a5a0804b0f9e914a959c539e82ed9125e30ee3f8a45ab50687c050038778179e"
    sha256 cellar: :any,                 arm64_ventura:  "065b4bba5f6f5da08fa3880d6408259e0d7589de22407d744e5010663379bfba"
    sha256 cellar: :any,                 arm64_monterey: "83c7f87651cb20df7227bf7010074df2ddf1240dbe936f3ee1dc69e24a92fb2f"
    sha256 cellar: :any,                 sonoma:         "d1ddd7ed8dd0bce2c0e173dd49cc2d9a2b0fa24c9ef007aa74379fab1b63f27f"
    sha256 cellar: :any,                 ventura:        "4e329fc722c29685d8ffedbe989b3e79ce8b60b424d0b5b4a73263e6ddba1d32"
    sha256 cellar: :any,                 monterey:       "ea65b68a6ec4aec7ecd77ea792eb3aecd2cbbfdf840e2f2648dfae0afb614c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "249fa07bc1dd60a559c8aaa9c9f13e8cf4aa4139c718a73c99576a0f8e5afb6c"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.12.tar.gz"
    sha256 "1ad84bb7d78cd3d0f8b6edbbb4c3a649f2b2c58c0f4b911b134317ea76c75135"
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
