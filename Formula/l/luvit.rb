class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 35
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "35ada557448e63eea2bbeae27320c3e6dc2113efb4e57827f671f6cb91f36dfd"
    sha256 cellar: :any, arm64_tahoe:       "c0c8c1dfa6fc483f6d1ad8d11bb70bd09a45dbf592752fb079ba2814b3c18d83"
    sha256 cellar: :any, arm64_sequoia:     "a0b08ccfce6c5b08c4f27cb36dc8b7dd1aeffea2967c77d3fcdc5bae699df55d"
    sha256 cellar: :any, arm64_linux:       "cb77879b327c6fbb23a07a729a5a76ef4a68298c93269a83e87ccc479ff8d4fb"
    sha256 cellar: :any, x86_64_linux:      "0323d146b251c3f9ad164664f6a767946f51ace79d62208fcb547c5b70409c8a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libuv"
  depends_on "luajit"
  # TODO: depends_on "luv"
  depends_on "openssl@4"
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

    # Backport changes for newer lua-openssl
    patch do
      url "https://github.com/luvit/luvi/commit/1ca5bab12976821f7f8283982a18f4fc2076ab75.patch?full_index=1"
      sha256 "8474fbb57bb7a60c48e3f6cffdda837b95ebda0b06e3982306247d0b1cb817a2"
      type :backport
    end
  end

  # Needed for OpenSSL 4 support. Remove when the `luvi`
  # resource has a new enough version as a submodule.
  resource "lua-openssl" do
    url "https://github.com/zhaozg/lua-openssl/releases/download/0.11.1-1/openssl-0.11.1-1.tar.gz"
    sha256 "b49a010d254a44669d4bb84292a5211d805fdd57e312ee78f799c261525abcaf"
  end

  deny_network_access!

  def install
    ENV["PREFIX"] = prefix
    luajit = Formula["luajit"]

    resource("luvi").stage do
      rm_r "deps/lua-openssl"
      resource("lua-openssl").stage("deps/lua-openssl")

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
