class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.37.1",
      revision: "8664c8334c05d322fbbdfb9e3b24601a23e9363c",
      shallow:  false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "123883d5fcb234baabbdd2123c5afabaab42b76923ad9a4f83473e1e45fa9f8c"
    sha256 cellar: :any, big_sur:       "3928041f47f3d9cfbcb8c52e9fef66bbeaf44b8805ba2808af3607fce47bd2c5"
    sha256 cellar: :any, catalina:      "5faf2cedba74b706a66e5976d80711eabfcbd349b46be581169d131761bf9de9"
    sha256 cellar: :any, mojave:        "7d026f00c805d4fb729cc4804d7f1ae50fa1c1f93d0f686fb91769ef6533b6a7"
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
