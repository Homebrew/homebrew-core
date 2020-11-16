class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    tag:      "v1.33.2",
    revision: "ee5b762f33a42170144834f5ab7efda9d76c480b",
    shallow:  false
  license "Apache-2.0"
  revision 1
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url "https://github.com/grpc/grpc/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "42e892a55e3fbbd128f65f48cfe8ae59414c15508c49128525841105fbe2ca5a" => :big_sur
    sha256 "b4336b217349d80961690d4ffeaf498be65855eba290847ae31f5c02f8e8ac4c" => :catalina
    sha256 "ac0adba235aabbea547163407944d441bd8ca30589f1d0778f6f508b67db6de9" => :mojave
    sha256 "762bcf5de8619962cad10d9692d3a6f9950af9c1db61f04c4d402449d0dda818" => :high_sierra
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
  depends_on "re2"

  def install
    mkdir "cmake/build" do
      args = %w[
        ../..
        -DCMAKE_CXX_STANDARD=17
        -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
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
