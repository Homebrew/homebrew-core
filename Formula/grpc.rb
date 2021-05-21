class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.38.0",
      revision: "54dc182082db941aa67c7c3f93ad858c99a16d7d",
      shallow:  false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "acc54d42cb0a9bb54bfaba6351cb6b065253ebd35cf2809fc27566c6c39a9df0"
    sha256 cellar: :any, big_sur:       "a290fd745d2f5508b74ba9cea3db3bf057f0a17793cdb646719ce56f9db39f6c"
    sha256 cellar: :any, catalina:      "04783738edea2c92d82f0b40c5108fbb61875bc9e5acf702b73b82341fe5c474"
    sha256 cellar: :any, mojave:        "298bd6caf34410bfe42eb443f75c98e40541b18adf7e526df292fbeb8eb16348"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@1.1"
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
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end
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

      on_macos do
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@1.1"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *pkg_config_flags, "-o", "test"
    system "./test"

    output = shell_output("grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end
