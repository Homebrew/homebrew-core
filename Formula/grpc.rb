class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.37.1",
      revision: "8664c8334c05d322fbbdfb9e3b24601a23e9363c",
      shallow:  false
  license "Apache-2.0"
  revision 1
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2f11475d08ab3bad8577f3cd7577da5af575bf6e5072f75769f5e9dd85b782a1"
    sha256 cellar: :any, big_sur:       "60262977e20371b8e818b7820792698a899999985d356c6ceee1b36289dbb128"
    sha256 cellar: :any, catalina:      "b02be4642bfce958727bf03bff51d2acf6e180830a67566969ce975a8a37f0a8"
    sha256 cellar: :any, mojave:        "9b3f8b20776fc5607a59bd0bad8c65c4c9d0a90e9e1fc44d2584581b236883f2"
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
    depends_on "llvm" => :build if MacOS.version <= :mojave
  end

  fails_with :clang do
    build 1100
    cause "Requires C++17 features not yet implemented"
  end

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    on_macos do
      ENV.llvm_clang if MacOS.version <= :mojave
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

      # grpc_cli does not build correctly with a non-/usr/local prefix.
      # Reported upstream at https://github.com/grpc/grpc/issues/25176
      # When removing the `unless` block, make sure to do the same for
      # the test block.
      unless Hardware::CPU.arm?
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
    unless Hardware::CPU.arm?
      output = shell_output("grpc_cli ls localhost:#{free_port} 2>&1", 1)
      assert_match "Received an error when querying services endpoint.", output
    end
  end
end
