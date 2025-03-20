class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.71.0",
      revision: "4e9357bca1408596663a218c0c608a4c0560a867"
  license "Apache-2.0"
  revision 1
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
    sha256                               arm64_sequoia: "491de4434f7245b0f75baebee6804fa79bbdd7004272bfd2332803634617e717"
    sha256                               arm64_sonoma:  "130e28c4a782f25c6d9e35b3e551da24983a9a3042e2c6f40de75269bfd47cc3"
    sha256                               arm64_ventura: "af0d19afaec71efc9d91fbb83610da8b78bdd422001c838c227d8ac61d665d87"
    sha256 cellar: :any,                 sonoma:        "dfdbb317632d882ba24fb1bdbcd51f483aa5d04b31d6a462d1c1773e5b4ca613"
    sha256 cellar: :any,                 ventura:       "30462b5367d26e38c0018cda7858f8d15b503aeaae21d7ab50e915d79b452b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c52d48643ce34cfbff5da58db5930538ae08890e9c689a89c9a571690a2eb67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d8dd8ebaa29c04d9a62131d1c9239d9bbec2def4d1dc8b11ac7fc367554b25"
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

    output = shell_output("#{bin}/grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end
