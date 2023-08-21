class GrpcAT154 < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.54.3",
      revision: "868412b573a0663c8db41558498caf44098f4390"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for a different version, so we have to check multiple
  # releases to identify the highest 1.54.x version.
  livecheck do
    url :stable
    regex(/^v?(1\.54(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfa00d3fae2fa2979f96586eb27b14bfd7b80c03d6063d096da4e66663dc333f"
    sha256 cellar: :any,                 arm64_monterey: "3af3788a10d4f87457e49701295175e7d7ea56ff3130aa86dde7e5509d0133b2"
    sha256 cellar: :any,                 arm64_big_sur:  "30ae9d7735656bbdcd1e93a1738d684ecb6d05d878217ad98279d3676cc9ab51"
    sha256 cellar: :any,                 ventura:        "64f3093de3222d52d44df48bb181d70d977306e115adaa9ce81cfc8329d26479"
    sha256 cellar: :any,                 monterey:       "9a40ad20338637b7b9a4faee58bef5b60c73cbe985482933e08dde0c1fb016e1"
    sha256 cellar: :any,                 big_sur:        "1594c126ff699b67f58a15c670bd2da87f2d4cc07d2200acbb5d831d0969536f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163546cd8b26a7784041581a12fc79bf01c2484b2805f988686ca7a059b15ecd"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "re2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause "Requires C++17 features not yet implemented"
  end

  fails_with gcc: "5" # C++17

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    mkdir "cmake/build" do
      args = %W[
        ../..
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
      ] + std_cmake_args

      system "cmake", *args
      system "make", "install"

      args = %W[
        ../..
        -DCMAKE_INSTALL_RPATH=#{rpath}
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=ON
      ] + std_cmake_args
      system "cmake", *args
      system "make", "grpc_cli"
      bin.install "grpc_cli"
      lib.install Dir[shared_library("libgrpc++_test_config", "*")]

      if OS.mac?
        # These are installed manually, so need to be relocated manually as well
        MachO::Tools.add_rpath(bin/"grpc_cli", rpath)
        MachO::Tools.add_rpath(lib/shared_library("libgrpc++_test_config"), rpath)
      end
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["protobuf@21"].opt_lib/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *pkg_config_flags, "-o", "test"
    system "./test"

    output = shell_output("#{bin}/grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end
