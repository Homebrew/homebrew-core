class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.0/apache-pulsar-2.7.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.0/apache-pulsar-2.7.0-src.tar.gz"
  sha256 "f1e8168b7f2b8bfc06c84f743eb4f3dfa5f8f376f087c5ef1532f998cf56bab4"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "e641637fb28781ecb290b663f0d0f9225827cb143888f0e76ff00b4993c84580" => :big_sur
    sha256 "2c7fb02b322cb489bd130f7d4fe768852ee1722957ba114397f8b92e76b76c31" => :arm64_big_sur
    sha256 "72d86995890d36d173f7dc6c1b3de98cc5b06ed13a5221c18e615a6a77a30e98" => :catalina
    sha256 "38188abb88dcbb062a867cd59a2354d0171b7962ec5ac32f61e4ef399e397782" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  def install
    cd "pulsar-client-cpp" do
      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_TESTS=OFF",
                      "-DBUILD_PYTHON_WRAPPER=OFF",
                      "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                      "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                      "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib"
      system "make", "pulsarShared", "pulsarStatic"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
