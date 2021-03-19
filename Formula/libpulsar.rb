class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-src.tar.gz"
  sha256 "99c57e23ee6b9621b97439684e141dce467a138356b058918bcd9be032cf8822"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e3253f91a1a4d106ed31258efa556536748f83fbed2444e5b848b01a78a9bd8c"
    sha256 cellar: :any, big_sur:       "81f0d54d4de03504764c7b1bbd02a5f7abaa5ae20c06c327473916c14860d298"
    sha256 cellar: :any, catalina:      "016a97206deb91a8aeac60d3eb9ecae8c81f3deab10d4c17e37f8ab34a80c3eb"
    sha256 cellar: :any, mojave:        "a8a3a7e1f633cfbf2e2c986eec043bf3ee84a021bb70a274268b40e457ab1955"
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
