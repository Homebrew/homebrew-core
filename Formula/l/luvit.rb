class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 4
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10c778cf86ac40105407b0ceb932fb7118d0a1e4ab05cf98475ba0ff23431956"
    sha256 cellar: :any,                 arm64_sequoia: "d104c6e0b03d4a00ad376cd5cb62392efe3e79f9b89cad0381e260512b675202"
    sha256 cellar: :any,                 arm64_sonoma:  "3ce6c7df064562119ea499918d4bd29dae0371f5bdf404d368b0a9af56d60e3e"
    sha256 cellar: :any,                 sonoma:        "aa5edeaf3cfc755a74884dfd4262947af981677a4e0ee2088cd877e080291a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f939dd8ecd44c2f17e4fb9df83b72e8bceac5e88b42852ea2d452591538045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1233bc60e1552d3c781ace739df06fa3df20980cfd61e8e72d4782a8f862ee79"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libuv"
  depends_on "luajit"
  # TODO: depends_on "luv"
  depends_on "openssl@3"
  depends_on "pcre2"

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
  # NOTE: Moved up to 2.15.0 for pcre2 and openssl@3 support
  resource "luvi" do
    url "https://github.com/luvit/luvi/releases/download/v2.15.0/luvi-source.tar.gz"
    sha256 "91f40fb6421888c2ee403de80248250c234f3bfb6dd1edbbc9188a89e4b9708a"

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
  end

  def install
    ENV["PREFIX"] = prefix
    luajit = Formula["luajit"]

    resource("luvi").stage do
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
        -DWithOpenSSL=ON
        -DWithSharedOpenSSL=ON
        -DWithPCRE2=ON
        -DWithLPEG=ON
        -DWithSharedPCRE2=ON
        -DWithSharedLibluv=ON
        -DLUV_INCLUDE_DIR=#{libexec}/include/luv
        -DLUV_LIBRARY=#{libexec}/lib/#{shared_library("libluv")}
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
