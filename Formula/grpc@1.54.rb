class GrpcAT154 < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.54.2",
      revision: "8871dab19b4ab5389e28474d25cfeea61283265c"
  license "Apache-2.0"
  revision 2

  # The "latest" release on GitHub is sometimes for an older major/minor and
  # there's sometimes a notable gap between when a version is tagged and
  # released, so we have to check the releases page instead.
  livecheck do
    url "https://github.com/grpc/grpc/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(1\.54(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "775fea94a0eeefad3d06cdae2755f1e90aa24587c822d817c5eaee5cd2ba2fa8"
    sha256 cellar: :any,                 arm64_monterey: "2cb19003000ed1349a02f39d4da38f8f9d756067432be20b2cb11ad518723b19"
    sha256 cellar: :any,                 arm64_big_sur:  "17a2506e7d24766720920f2d2c0d44135ad81fb9ea154f413540ccb1090c7841"
    sha256 cellar: :any,                 ventura:        "f589f329facf71cfc71ea22420a86db3c19527cff706bf3d44c147d089afc7d4"
    sha256 cellar: :any,                 monterey:       "7e44ee6f0a402c7f296d14874b6e1e0a3db99391db1f833217d00016c1f52c5d"
    sha256 cellar: :any,                 big_sur:        "dd998b5ab6d30cf4feac44705a48cdadd12142f15c6103752e739964b42f3594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab0c381e613c4bf4fb7acdf23cb8a6b19348bda1d107f0464ce27c85d31b0c9b"
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
