class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.2/apache-pulsar-2.7.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.2/apache-pulsar-2.7.2-src.tar.gz"
  sha256 "2e125df2ccf374e237676fb036ca00cb4d076d1683b86c672161888f5a5ef32f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4d1c159326f854f9b4797e0c7011bff9938c9cf78af82c0a91bed364f8ca8a52"
    sha256 cellar: :any, big_sur:       "bfb533888df0fdc8249c5893c4ec02702135ed0ecfe8ef55333107cdb998b46c"
    sha256 cellar: :any, catalina:      "2d3c809a9dc969a98512444f1dab6afae08690c8d765ef420b86ea5d97552755"
    sha256 cellar: :any, mojave:        "ca26d267f9306739aa6df240903b430262513ae359dfcc68b41e90b9a65a501e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

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

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
