class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.78.1",
      revision: "5b6492ea90b2b867a6adad1b10a6edda28e860d1"
  license "Apache-2.0"
  revision 3
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
    sha256 cellar: :any, arm64_tahoe:   "571941b833eb2c5b12c09d86925b8c3b7b7d2a6928d9c6cf793d6864a488e9a5"
    sha256 cellar: :any, arm64_sequoia: "4ad66b40270657c3fe016882300dfaeae668ad636521b4c53a66d41a8b022535"
    sha256 cellar: :any, arm64_sonoma:  "4eb9e0820d895e4e2ced82eb5d93c92eb0c576607280ab53219471135e3523d9"
    sha256 cellar: :any, sonoma:        "ea65b61ca7c36fbca750541a4f987b3a9cf4ed71a465f3b9e0f424288e87a944"
    sha256               arm64_linux:   "1b37f25fa8979c0d93b03d397564d7df4b14876518e0e578752c54a434a3b942"
    sha256               x86_64_linux:  "552d9d669bfc0d08a30d6d9c51cdebc8279d7744e3430e7dacf803856ed87798"
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
      -DCMAKE_CXX_STANDARD=17
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
    odie "Remove grpc_cli!" if build.stable? && version >= "1.80.0"
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
    lib.install (buildpath/"_build-grpc_cli").glob(shared_library("libgrpc++_test_config", "*"))
    libexec.install "_build-grpc_cli/grpc_cli"
    (bin/"grpc_cli").write <<~SHELL
      #!/bin/bash
      echo "WARNING: grpc_cli will be removed from grpc formula in version 1.80.0" >&2
      exec "#{libexec}/grpc_cli" "$@"
    SHELL
  end

  def caveats
    on_macos do
      "grpc_cli will be removed from grpc formula in 1.80.0"
    end
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
