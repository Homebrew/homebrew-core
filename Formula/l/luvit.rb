class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "6b60306e827d1ae928e60c37b00b83ca10a5bdfb02b0a67812e1eb999827c96d"
    sha256 cellar: :any,                 arm64_sonoma:  "b0eb78bcb741a4096ecfdfcbf8656f73a1a36de52027ac2a1f001b646ff5c260"
    sha256 cellar: :any,                 arm64_ventura: "4617df0255020cc2092491fcae316e8b24bb3dbad41199d478adc2347354be1d"
    sha256 cellar: :any,                 sonoma:        "f339f8f017f800383975270f241aa1b422581d9bbb23968a3a93f1a414bb406c"
    sha256 cellar: :any,                 ventura:       "a8ccb357aa21457d1faf621fda482fa4f70997121f31fd77256974a79d409e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f938d579e8d759b9880b38f4f8ad8aa6caab85b0e500c3a082b611a003e7ad1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libuv"
  depends_on "luajit"
  depends_on "luv"
  depends_on "openssl@3"
  depends_on "pcre"

  conflicts_with "lit", because: "both install `lit` binaries"

  # To update this resource, check LIT_VERSION in the Makefile:
  # https://github.com/luvit/luvit/blob/#{version}/Makefile
  resource "lit" do
    url "https://github.com/luvit/lit.git",
        tag:      "3.8.5",
        revision: "84fc5d729f1088b3b93bc9a55d1f7a245bca861d"

    livecheck do
      url "https://raw.githubusercontent.com/luvit/luvit/#{LATEST_VERSION}/Makefile"
      regex(/LIT_VERSION=["']?(\d+(?:\.\d+)+)["']?$/i)
    end
  end

  # To update this resource, check LUVI_VERSION in
  # https://github.com/luvit/lit/raw/$(LIT_VERSION)/get-lit.sh
  resource "luvi" do
    url "https://github.com/luvit/luvi.git",
        tag:      "v2.12.0",
        revision: "5d1052f11e813ff9edc3ec75b5282b3e6cb0f3bf"

    livecheck do
      url "https://raw.githubusercontent.com/luvit/luvit/#{LATEST_VERSION}/Makefile"
      regex(/LIT_VERSION=["']?(\d+(?:\.\d+)+)["']?$/i)
      strategy :page_match do |page, regex|
        lit_version = page[regex, 1]
        next if lit_version.blank?

        get_lit_page = Homebrew::Livecheck::Strategy.page_content(
          "https://raw.githubusercontent.com/luvit/lit/#{lit_version}/get-lit.sh",
        )
        next if get_lit_page[:content].blank?

        get_lit_page[:content][/LUVI_VERSION:-v?(\d+(?:\.\d+)+)/i, 1]
      end
    end

    # Remove outdated linker flags that break the ARM build.
    # https://github.com/luvit/luvi/pull/261
    patch do
      url "https://github.com/luvit/luvi/commit/b2e501deb407c44a9a3e7f4d8e4b5dc500e7a196.patch?full_index=1"
      sha256 "be3315f7cf8a9e43f1db39d0ef55698f09e871bea0f508774d0135c6375f4291"
    end
  end

  # Needed for OpenSSL 3 support. Remove when the `luvi`
  # resource has a new enough version as a submodule.
  resource "lua-openssl" do
    url "https://github.com/zhaozg/lua-openssl/releases/download/0.8.3-1/openssl-0.8.3-1.tar.gz"
    sha256 "d8c50601cb0a04e2dfbd8d8e57f4cf16a4fe59bdca8036deb8bc26f700f2eb8c"
  end

  def install
    if DevelopmentTools.clang_build_version >= 1500
      # Work around build error in current `lua-openssl` resource with newer Clang
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"
      # Use ld_classic to work around 'ld: multiple errors: LINKEDIT overlap of start of
      # LINKEDIT and symbol table in '.../jitted_tmp/src/lua/luvibundle.lua_luvi_generated.o'
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

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

      rm_r "deps/lua-openssl"
      Pathname("deps/lua-openssl").install resource("lua-openssl")

      # CMake flags adapted from
      # https://github.com/luvit/luvi/blob/#{luvi_version}/Makefile#L73-L74
      luvi_args = %W[
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

      system "cmake", "-S", ".", "-B", "build", *luvi_args, *std_cmake_args
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
