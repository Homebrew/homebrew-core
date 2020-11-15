class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.6.2/apache-pulsar-2.6.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.6.2/apache-pulsar-2.6.2-src.tar.gz"
  sha256 "10dbb8679df49a0b5c2f0e24962c1044772a93276e92fcea7095fc73f490b98a"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "98622d8b32cb59479449de025940054e4ffb001bc8fa7b66e1aa1fb7ee771625" => :big_sur
    sha256 "6ae3a09bdf3f9d004987c2bd8c9758413c6c7967bfe20e69060b1604fc5214ed" => :catalina
    sha256 "39503de9e5133044c936900cc377d1bd08bcb85c7f73d4f0c32cb1e51204d506" => :mojave
    sha256 "c13ea34b080117c3ac9f57e4b15cbc9195a94628ecd738bd005a944f421fada9" => :high_sierra
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
