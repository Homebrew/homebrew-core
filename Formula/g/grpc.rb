class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.75.0",
      revision: "093085cc925e0d5aa6e92bc29e917f9bdc00add2"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8845c5241c556f82e8850600a2bde0242d5149d3785bd42145c6ca49f2fa686f"
    sha256 cellar: :any, arm64_sequoia: "d338a48c258a4a191aa0e5fef0beb282745c136568ce615f34df4f6ea12e7ee0"
    sha256 cellar: :any, arm64_sonoma:  "d8ecb7db4d2c847d9e2398ac98ae7ce534245c9cceffe3ef21c7ef088f7c0e30"
    sha256 cellar: :any, sonoma:        "7b816467a9129ef582a9e13a4e5f5647391702f8d6adc5e8f830909e33738591"
    sha256               arm64_linux:   "abe334599338ffd9ce20cbe9ad57a131df13cfd9b022b3341aa1b21a902bfa5c"
    sha256               x86_64_linux:  "f802d999ae3b7ca1e95c8283cda5542a686f0604d7653a0a5bc416de5e947091"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause "Requires C++17 features not yet implemented"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_BUILD_TESTS=OFF
      -DgRPC_INSTALL=ON
      -DgRPC_ABSL_PROVIDER=package
      -DgRPC_CARES_PROVIDER=package
      -DgRPC_PROTOBUF_PROVIDER=package
      -DgRPC_SSL_PROVIDER=package
      -DgRPC_ZLIB_PROVIDER=package
      -DgRPC_RE2_PROVIDER=package
    ]
    linker_flags = []
    linker_flags += %w[-undefined dynamic_lookup] if OS.mac?
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if linker_flags.present?
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # `grpc_cli` fails to build on Linux. In any case, it looks like it isn't meant to be be installed.
    # TODO: consider dropping this on macOS too.
    return unless OS.mac?

    # The following are installed manually, so need to use CMAKE_*_LINKER_FLAGS
    # TODO: `grpc_cli` is a huge pain to install. Consider removing it.
    linker_flags += %W[-rpath #{rpath} -rpath #{rpath(target: HOMEBREW_PREFIX/"lib")}]
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}
      -DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_BUILD_TESTS=ON
      -DgRPC_ABSL_PROVIDER=package
      -DgRPC_CARES_PROVIDER=package
      -DgRPC_PROTOBUF_PROVIDER=package
      -DgRPC_SSL_PROVIDER=package
      -DgRPC_ZLIB_PROVIDER=package
      -DgRPC_RE2_PROVIDER=package
    ]
    system "cmake", "-S", ".", "-B", "_build-grpc_cli", *args, *std_cmake_args
    system "cmake", "--build", "_build-grpc_cli", "--target", "grpc_cli"
    bin.install "_build-grpc_cli/grpc_cli"
    lib.install (buildpath/"_build-grpc_cli").glob(shared_library("libgrpc++_test_config", "*"))
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    CPP
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *flags, "-o", "test"
    system "./test"

    # We don't build `grpc_cli` on Linux.
    return unless OS.mac?

    output = shell_output("#{bin}/grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end
