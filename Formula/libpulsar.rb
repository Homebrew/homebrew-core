class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.2/apache-pulsar-2.4.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.4.2/apache-pulsar-2.4.2-src.tar.gz"
  sha256 "4b543932db923aa135c4d54b9122bcbdfc67bd73de641f9fffbc9a4ddf3430ae"
  revision 1

  bottle do
    cellar :any
    sha256 "13c37b77dee18f4bba454484b4426a6f3dad27f902e0793a56a6358897ab4f3f" => :catalina
    sha256 "ff0090b77842ac6034c4a425438f8d5b401164da4bada7ac11c4963dcdaa3a28" => :mojave
    sha256 "d73f612edf73a351ab7f90776c24670c4c77b85fd95e37999e863ff27daf89ef" => :high_sierra
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
