class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed6d081d3a0d4f3d89f02f5d6ff038dd9e9b9b98b0596a33e5b18bdbc598c45c"
    sha256 cellar: :any,                 arm64_ventura:  "20bc43f46fbe2135a5ca45feb75e6bd90f1825437ff5fcc3a706ee96d886e5fc"
    sha256 cellar: :any,                 arm64_monterey: "ebb8ed1a318977d2227e7f9fb9310cdbe5632f4448dd9447d9e826b1b231744b"
    sha256 cellar: :any,                 arm64_big_sur:  "e4237394b4ac43b8066fd13464282869aae5665c900c4bb981465aba60fc5196"
    sha256 cellar: :any,                 sonoma:         "fa82bfb69e426f3103200b2f78d2ced2f69202072ea07c6303c2949be5265dcd"
    sha256 cellar: :any,                 ventura:        "4588bc9f5c49c4d3c4a9683abcc56ba9ecc7ef4112252d0df5357f9690116d6d"
    sha256 cellar: :any,                 monterey:       "9b9cbe57a9bcfd827641084cb1b3cf942e5c4967d9fc6e87cbf5bcd1ab73b67c"
    sha256 cellar: :any,                 big_sur:        "92b1351e005d37bbdf7018bcefeeaf461d65b973121b5fc540fff23cdf067925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e701f35d1f4adb5e8a60e05768ec142e58c271e8c222821ad27c21445e8839de"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

      system "cmake", ".", "-B", "build", *luvi_args, *std_cmake_args
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
