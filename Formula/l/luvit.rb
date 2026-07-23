class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 22
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80e5fb0334de0ba7e8b39b79eaebe9c3fde8566cc47c31befab1bc7830823853"
    sha256 cellar: :any, arm64_sequoia: "b85629370edbfa201ee92b47702c586f9d52d2fbac6e475e9b438eed28e57ce2"
    sha256 cellar: :any, arm64_sonoma:  "94212736830b492bce5c43b8db3ed00267a6ab0048dda167b4a9dd0bd61ef4bd"
    sha256 cellar: :any, sonoma:        "c4558a12d8bde00536444cbbd1700c79dc56c06a530abad621db5f0b452e6c8c"
    sha256 cellar: :any, arm64_linux:   "8ab76755cae70bd1093a95cc236748146f9ea34b476c9d62eefee00a79b31b9e"
    sha256 cellar: :any, x86_64_linux:  "65e42c17fe8f3680cf48bac2db093ac5e636310a4343cde4fa856525eac8f6fd"
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
