class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.36.4",
      revision: "3e53dbe8213137d2c731ecd4d88ebd2948941d75",
      shallow:  false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "3f207e9539804eaca38348f545cd5c6637f4d0fb3d4b70b4465edc004d14bc47"
    sha256 big_sur:       "82f42f253f2ec4dbc7242d616181e706b978cb83ca708bfd0b976dbd47472d13"
    sha256 catalina:      "fbd524f31f1a0526c49a61a8fd9f6c8dfb0867765c67342ab7c8bef15b025541"
    sha256 mojave:        "1be9b0b8660fc7a74a7165db297aaf5ef3651d676b964fa79e4495145fa12621"
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

  def install
    mkdir "cmake/build" do
      args = %W[
        ../..
        -DCMAKE_CXX_STANDARD=17
        -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
        -DCMAKE_INSTALL_RPATH=#{lib}
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
          -DCMAKE_INSTALL_RPATH=#{lib}
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
