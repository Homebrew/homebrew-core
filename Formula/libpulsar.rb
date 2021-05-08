class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-src.tar.gz"
  sha256 "99c57e23ee6b9621b97439684e141dce467a138356b058918bcd9be032cf8822"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "3381734d8b433507a1d68d0705b974be358471ee4cf5affe42c019b55731e302"
    sha256 cellar: :any, big_sur:       "e75fcd67b4b8e552825de5da62f4d74939d70959a85de813c14a02b814d4ed6a"
    sha256 cellar: :any, catalina:      "a7b98f1c760b5ca0c64923fa9768219686abc2dc9efc0fa3b238782b8dc95917"
    sha256 cellar: :any, mojave:        "a71001214539bcc65d06a563d6f17809017ee955a77e3b7e3046d163236b673a"
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
