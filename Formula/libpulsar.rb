class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-src.tar.gz"
  sha256 "99c57e23ee6b9621b97439684e141dce467a138356b058918bcd9be032cf8822"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8ea4f7e297ce392a28856902abf356c7d934e9bf9ed1c2bd03bc66d8a370a789"
    sha256 cellar: :any, big_sur:       "fb909cb58681fc6cf2586691d0987c55f3dcbb3076cfc2412bc5b3302b1199af"
    sha256 cellar: :any, catalina:      "e1a138a25c00222b18500a5a23ba67cb759fcce7fe2c6693209b19b8cb101e6a"
    sha256 cellar: :any, mojave:        "cfef2ac5b8552ec1ab8322b01e039a782b331ed404be5f46c251c77aea96cddc"
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
