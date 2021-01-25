class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.17.0.tar.gz"
  sha256 "80657aa752322560fcde780212b6807b626b45d65aca3f3dae254e5c4fb0ee78"
  license "Apache-2.0"
  revision 1
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any
    sha256 "8c0a060b75b4f877e4df310e7ebe3c9159e7536bce244731b1c21f9bf96b4a60" => :big_sur
    sha256 "e5aa766db0f5760ebb217a462540f13b2ca221474ca22fd9cd710e79333a1bb6" => :catalina
    sha256 "2d0d77fceac6194e9329eba75f015c8b870ad9a32d2b76c4785126f7642fc665" => :mojave
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
        tag:      "3.8.1",
        revision: "27114d94b9299437b2229eac6a6c3a9ef41fa83a"
  end

  # To update this resource, check LUVI_VERSION in
  # https://github.com/luvit/lit/raw/$(LIT_VERSION)/get-lit.sh
  resource "luvi" do
    url "https://github.com/luvit/luvi.git",
        tag:      "v2.11.0",
        revision: "9da12caaf01337ef0609d07b2af9a5296c13922a"
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
