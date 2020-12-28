class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.33.2",
      revision: "ee5b762f33a42170144834f5ab7efda9d76c480b",
      shallow:  false
  license "Apache-2.0"
  revision 2
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "94f48994c3cfdf7ed6c0758caddf2ce3ab4382b129a382e6ea263c1f58a659c5" => :big_sur
    sha256 "674373931a0c55ea13f4931169f01811ac309a942d9f1d10ef10ba5b43ab1c24" => :catalina
    sha256 "3d0d1ca1014d635e2876cfc36543662312f4a4e3a7ec5c0f711b7e4e0ace6a35" => :mojave
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

  uses_from_macos "zlib"

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
      lib.install Dir["libgrpc++_test_config*.{dylib,so}.*"]
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
