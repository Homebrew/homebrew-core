class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    sha256 cellar: :any, monterey: "a2aaf725d698267ef575d5a5da6067de5b67bd96f4eef68bcf17897970decb36"
    sha256 cellar: :any, big_sur:  "ca454af75b9d587eb17e722d978021ab480a7a14241dd6d4b127ce462cb1ada3"
    sha256 cellar: :any, catalina: "2b555b4d3c8ccd6c44f919013620e6230f56de5edba9105c9fb20f46354aa944"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libuv"
  depends_on "luajit"
  depends_on "luv"
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

    # Remove outdated linker flags that break the ARM build.
    # https://github.com/luvit/luvi/pull/261
    patch do
      url "https://github.com/luvit/luvi/commit/b2e501deb407c44a9a3e7f4d8e4b5dc500e7a196.patch?full_index=1"
      sha256 "be3315f7cf8a9e43f1db39d0ef55698f09e871bea0f508774d0135c6375f4291"
    end
  end

  def install
    ENV["PREFIX"] = prefix
    luajit = Formula["luajit"]
    luv = Formula["luv"]

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
        -DLIBLUV_INCLUDE_DIR=#{luv.opt_include}/luv
        -DLIBLUV_LIBRARIES=#{luv.opt_lib/shared_library("libluv")}
        -DLUAJIT_INCLUDE_DIR=#{luajit.opt_include}/luajit-2.1
        -DLUAJIT_LIBRARIES=#{luajit.opt_lib/shared_library("libluajit")}
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
