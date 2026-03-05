class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.78.1",
      revision: "5b6492ea90b2b867a6adad1b10a6edda28e860d1"
  license "Apache-2.0"
  revision 2
  compatibility_version 1
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
    sha256 cellar: :any, arm64_tahoe:   "dfde9b2bdd706c7dd90e8b552edbcced92afb8a42f54a7e39aff102e2b1755ef"
    sha256 cellar: :any, arm64_sequoia: "792d3130e725f3f02b9a57f85c6e688adf7af362e57b14aa631ecc48e22b60a7"
    sha256 cellar: :any, arm64_sonoma:  "e89bdc77b95eafe184629c8e3e233e0469cee2ac34f68d934b6cbf2ff19ab21a"
    sha256 cellar: :any, sonoma:        "959919be7e85ad43e06dae7d5b76ec91b5bae106c758d71f3a3911bf44837e98"
    sha256               arm64_linux:   "faa60f8447dbe3ff42fb2ac86e93b29ec3df1025e1af70d4b2d06eed3c9c8dee"
    sha256               x86_64_linux:  "6e923857c20dcef6b434051e27126a4eddd17aefcbec0818d67126ef2e25bddd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1100
    cause "Requires C++17 features not yet implemented"
  end

  # Apply open PR to support building grpc_cli with Protobuf 34+
  # PR ref: https://github.com/grpc/grpc/pull/41775
  patch do
    url "https://github.com/grpc/grpc/commit/168b069208538e58a72bf46a6410f9ac0d24019a.patch?full_index=1"
    sha256 "406731204b925c3ba57c8dc84da573b2755c3365cd59c1f0a04c1791f7db6565"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_INSTALL=ON
      -DgRPC_ABSL_PROVIDER=package
      -DgRPC_CARES_PROVIDER=package
      -DgRPC_PROTOBUF_PROVIDER=package
      -DgRPC_SSL_PROVIDER=package
      -DgRPC_ZLIB_PROVIDER=package
      -DgRPC_RE2_PROVIDER=package
    ]
    system "cmake", "-S", ".", "-B", "_build", "-DgRPC_BUILD_TESTS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # `grpc_cli` fails to build on Linux. In any case, it looks like it isn't meant to be installed.
    # TODO: consider dropping this on macOS too.
    return unless OS.mac?

    # The following are installed manually, so need to use CMAKE_*_LINKER_FLAGS
    # TODO: `grpc_cli` is a huge pain to install. Consider removing it.
    linker_flags = %W[-rpath #{rpath}]
    grpc_cli_args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}
      -DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}
      -DgRPC_BUILD_TESTS=ON
    ]
    system "cmake", "-S", ".", "-B", "_build-grpc_cli", *args, *grpc_cli_args, *std_cmake_args
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["zlib-ng-compat"].opt_lib/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *flags, "-o", "test"
    system "./test"

    # We don't build `grpc_cli` on Linux.
    return unless OS.mac?

    output = shell_output("#{bin}/grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end
