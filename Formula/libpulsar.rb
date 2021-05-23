class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.2/apache-pulsar-2.7.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.2/apache-pulsar-2.7.2-src.tar.gz"
  sha256 "2e125df2ccf374e237676fb036ca00cb4d076d1683b86c672161888f5a5ef32f"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fb1c730eb3e9ebfaedfbc003ef3fa66c09d850b4d7be54a29e6af1e2a5bc3b63"
    sha256 cellar: :any, big_sur:       "84c5f6620b006c8d8b33bd192daf8b42bae83d30b911300178f84d7365b859cd"
    sha256 cellar: :any, catalina:      "e6a308fddf37ac36330260ac8eea7ba91ed058eaddb5de3b0bcf87f48d5208e6"
    sha256 cellar: :any, mojave:        "715ba63fe4ba9936574fd89d31e8ffa9d86ed9c0dba5fc3a4fe55c0b8a94a096"
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
