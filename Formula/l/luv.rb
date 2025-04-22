class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/1.50.0-1.tar.gz"
  sha256 "bb4f0570571e40c1d2a7644f6f9c1309a6ccdb19bf4d397e8d7bfd0c6b88e613"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d90f24b39208b2d38575647b97796e59711e86da665350d2e04f1eba29014e2e"
    sha256 cellar: :any,                 arm64_sonoma:  "7a1f6cb24fb6cfb862bd44c23995326b0f45816e792522c9ff19bd9ea5ea1a71"
    sha256 cellar: :any,                 arm64_ventura: "8e31ff6907a7e940f8b461fd5c8ea8896c546641d7038eb21d6da0e32ee4a004"
    sha256 cellar: :any,                 sonoma:        "5495b4d31f5856d371bf0fc4d7f5db89f6cb08dc1e0dfbfeb4f0903bd5eb28f1"
    sha256 cellar: :any,                 ventura:       "d0f47a32674eb2aae12ab50cd2ba3749a41ee581fadb3b4114477e9503385263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46ec46647ebd9d2f08e136f88413081fcec19fe80536ee0f467a2ae14ca01169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9083575ea116986d84c08971cc2f80011996968c2c7e3d02d0505c9407def6"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.14.4.tar.gz"
    sha256 "a9afa2eb812996039a05c5101067e6a31af9a75eded998937a1ce814afe1b150"
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
