class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.18.0.tar.gz"
  sha256 "3c6824878189ca41059d6d4cd8b1646de0ec6b4be1de71b2084f98c36c38e84e"
  license "Apache-2.0"
  head "https://github.com/luvit/luvit.git"

  bottle do
    sha256 cellar: :any, monterey: "010eed765a7f08a3674277000ea35ac980a69dd2746bb98ade221186681676e3"
    sha256 cellar: :any, big_sur:  "f5d4e01cac025c30275ca2caf6cd692565121a5c40674e82ed28264f3fcdfd94"
    sha256 cellar: :any, catalina: "25f788eba25ec7dd095172eb94f9afb08b259040656fb26c8173bc784857e18b"
    sha256 cellar: :any, mojave:   "e9d97bb1ea6f67020c8f02c3009edf46b45d249654df5ea134889526c082ba97"
  end

  depends_on "cmake" => :build
  depends_on "luajit-openresty" => :build
  depends_on "luv" => :build
  depends_on "pkg-config" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "pcre"

  # To update this resource, check LIT_VERSION in the Makefile:
  # https://github.com/luvit/luvit/blob/#{version}/Makefile
  resource "lit" do
    url "https://github.com/luvit/lit.git",
        tag:      "3.8.5",
        revision: "84fc5d729f1088b3b93bc9a55d1f7a245bca861d"
  end

  # To update this resource, check LUVI_VERSION in
  # https://github.com/luvit/lit/raw/$(LIT_VERSION)/get-lit.sh
  resource "luvi" do
    url "https://github.com/luvit/luvi.git",
        tag:      "v2.12.0",
        revision: "5d1052f11e813ff9edc3ec75b5282b3e6cb0f3bf"
  end

  def install
    ENV["PREFIX"] = prefix
    luajit = Formula["luajit-openresty"]

    resource("luvi").stage do
      # Build scripts set LUA_PATH before invoking LuaJIT, but that causes errors.
      # Reported at https://github.com/luvit/luvi/issues/242
      inreplace "cmake/Modules/LuaJITAddExecutable.cmake",
                "COMMAND \"LUA_PATH=${LUA_PATH}\" luajit", "COMMAND luajit"

      # Build scripts double the prefix of this directory, so we set it manually.
      # Reported in the issue linked above.
      ENV["LPEGLIB_DIR"] = "deps/lpeg"

      # CMake flags adapted from
      # https://github.com/luvit/luvi/blob/#{luvi_version}/Makefile#L73-L74
      luvi_args = std_cmake_args + %W[
        -DWithOpenSSL=ON
        -DWithSharedOpenSSL=ON
        -DWithPCRE=ON
        -DWithLPEG=ON
        -DWithSharedPCRE=ON
        -DWithSharedLibluv=ON
        -DLIBLUV_INCLUDE_DIR=#{Formula["luv"].opt_include}/luv
        -DLIBLUV_LIBRARIES=#{Formula["luv"].opt_lib}/libluv_a.a
        -DLUAJIT_INCLUDE_DIR=#{luajit.opt_include}/luajit-2.1
        -DLUAJIT_LIBRARIES=#{luajit.opt_lib}/libluajit.a
      ]

      system "cmake", ".", "-B", "build", *luvi_args
      system "cmake", "--build", "build"
      buildpath.install "build/luvi"
    end

    resource("lit").stage do
      system buildpath/"luvi", ".", "--", "make", ".", buildpath/"lit", buildpath/"luvi"
    end

    system "make", "install"
  end

  test do
    assert_equal "Hello World\n", shell_output("#{bin}/luvit -e 'print(\"Hello World\")'")
  end
end
