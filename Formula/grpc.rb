class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    tag:      "v1.32.0",
    revision: "414bb8322de2411eee1f4e841ff29d887bec7884",
    shallow:  false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url "https://github.com/grpc/grpc/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "3efaa235c102fc5e1ed2c2120a81cad4357b482931ae9a74231e5b964877caf7" => :catalina
    sha256 "876faceb8a3eb484a58d091242b797dd1379442c9bd710a8bbf75564b403cb82" => :mojave
    sha256 "5371f4c1d147650b81b384eeb0e0a247e492abc61b8b6ebb13194e68c19f95b3" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  def install
    mkdir "cmake/build" do
      args = %w[
        ../..
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=OFF
        -DgRPC_INSTALL=ON
        -DgRPC_ABSL_PROVIDER=package
        -DgRPC_CARES_PROVIDER=package
        -DgRPC_PROTOBUF_PROVIDER=package
        -DgRPC_SSL_PROVIDER=package
        -DgRPC_ZLIB_PROVIDER=package
      ] + std_cmake_args

      system "cmake", *args
      system "make", "install"

      args = %w[
        ../..
        -DCMAKE_EXE_LINKER_FLAGS=-lgflags
        -DCMAKE_SHARED_LINKER_FLAGS=-lgflags
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=ON
        -DgRPC_GFLAGS_PROVIDER=package
      ] + std_cmake_args
      system "cmake", *args
      system "make", "grpc_cli"
      bin.install "grpc_cli"
      lib.install Dir["libgrpc++_test_config*.dylib"]
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
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
