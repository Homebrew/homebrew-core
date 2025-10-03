class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/luvit/luvit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "17d057bd4ad2a454a31b24662102fff392681e72675de5d64e5deb1dfe7af479"
    sha256 cellar: :any,                 arm64_sequoia: "50c277e8b5c4ac5d75481e09e520a8d119d997d7ab420ab01c5d2e9e700f08a7"
    sha256 cellar: :any,                 arm64_sonoma:  "0ef80abb496d68a40c367126cfc343da468e67161b18f96bd239914166ce5875"
    sha256 cellar: :any,                 sonoma:        "2a28032e61257c09d6282ae24a2e0cd64b97de9279a3337a7966b4cf36afedae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c7531ea1451526770ec5f04853cc6cc1b9a9db3803418bb3d8d5e36000f8456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7587270f4a47365d876feb28f09e2be713dea9bf8dd666e019071b93738d2c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libuv"
  depends_on "luajit"
  # TODO: depends_on "luv"
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
    url "https://github.com/luvit/luvi/releases/download/v2.12.0/luvi-src-v2.12.0.tar.gz"
    sha256 "4149c87646f487f9076c29e9861f64468637b1d1361b777b093e6204a83e1ed9"

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

      # Build the bundled `luv` as `luvi` is not compatible with newer version.
      # We cannot use `-DWithSharedLibluv=OFF` as it will bundle `luajit` too.
      # TODO: Restore brew `luv` once support is available
      system "cmake", "-S", "deps/luv", "-B", "build_luv",
                      "-DBUILD_MODULE=ON",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DBUILD_STATIC_LIBS=OFF",
                      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                      "-DLUA_BUILD_TYPE=System",
                      "-DWITH_LUA_ENGINE=LuaJIT",
                      "-DWITH_SHARED_LIBUV=ON",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build_luv"
      system "cmake", "--install", "build_luv"

      # CMake flags adapted from
      # https://github.com/luvit/luvi/blob/#{luvi_version}/Makefile#L73-L74
      luvi_args = %W[
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        -DWithOpenSSL=ON
        -DWithSharedOpenSSL=ON
        -DWithPCRE=ON
        -DWithLPEG=ON
        -DWithSharedPCRE=ON
        -DWithSharedLibluv=ON
        -DLIBLUV_INCLUDE_DIR=#{libexec}/include/luv
        -DLIBLUV_LIBRARIES=#{libexec}/lib/#{shared_library("libluv")}
        -DLUAJIT_INCLUDE_DIR=#{luajit.opt_include}/luajit-2.1
        -DLUAJIT_LIBRARIES=#{luajit.opt_lib/shared_library("libluajit")}
      ]

      system "cmake", "-S", ".", "-B", "build", *luvi_args, *std_cmake_args
      system "cmake", "--build", "build"
      bin.install "build/luvi"
    end

    # See "Sharing Luvi Across Apps": https://luvit.io/blog/alpine-luvi.html
    (buildpath/"luvi").write "#!#{bin}/luvi --\n"

    resource("lit").stage do
      system bin/"luvi", ".", "--", "make", ".", bin/"lit", buildpath/"luvi"
    end

    system bin/"lit", "make", ".", bin/"luvit", buildpath/"luvi"
  end

  test do
    assert_equal "Hello World\n", shell_output("#{bin}/luvit -e 'print(\"Hello World\")'")
  end
end
