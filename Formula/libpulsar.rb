class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.8.0/apache-pulsar-2.8.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.8.0/apache-pulsar-2.8.0-src.tar.gz"
  sha256 "0e161a81c62c7234c1e0c243bb6fe30046ec1cd01472618573ecdc2a73b1163b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2e3dffc6ac480c7acfd625c6e3a382c7316f6bbd467ac1c3d12bd3a4a7ddf22b"
    sha256 cellar: :any, big_sur:       "f5f55678e946fe389898923eba165006ca93e7574518cc52270d1d89960d858a"
    sha256 cellar: :any, catalina:      "0600145b0af61c4893aa54ad41ca3d6b92ee7fd6906c202f6b9ec405ef4dadcc"
    sha256 cellar: :any, mojave:        "bc82229be13f8025dfbb39edee256d0771953fea4cd12430ba10b12cbcdc7a4a"
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
