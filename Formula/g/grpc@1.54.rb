class GrpcAT154 < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.54.3",
      revision: "868412b573a0663c8db41558498caf44098f4390"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf92a1cc58e01fea2cc5344d1bf56cc4599a621a19221afefb973b8b54c8c324"
    sha256 cellar: :any,                 arm64_ventura:  "0631cf6a63fca83abd8ff53b0a41811957c8efaf7a422a9f1987f5ee2fa4f88e"
    sha256 cellar: :any,                 arm64_monterey: "b757a9ba28c98f1a0b2190c4fd8d30fd578b8024271295dda9940494a7184eb4"
    sha256 cellar: :any,                 arm64_big_sur:  "56e870bfa7c06a1726ffd4661f1d7a7e74fe9688b80544a44244262b40e64e3a"
    sha256 cellar: :any,                 sonoma:         "381a3af7f47c997510798e7e4636ef9ccfb54247661fa46759ba0d3ea2be4290"
    sha256 cellar: :any,                 ventura:        "8d73e997bc07465c96293af80e0530efdeaa92efe93fbb4bf73953895780e0ca"
    sha256 cellar: :any,                 monterey:       "3452857ae337fc8dfd15501a3794638692afb3f416643c072f966aa2ad76d755"
    sha256 cellar: :any,                 big_sur:        "6217233621ae1a4e337f64f5f6e0b7202e45266bddec1d33b13f272dd9675659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d7467fb3e8243d7981ad883cc4a9838d477da3fd4b3e5cdbafb9b30ea84e7f"
  end

  keg_only :versioned_formula

  deprecate! date: "2024-02-25", because: :versioned_formula

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
