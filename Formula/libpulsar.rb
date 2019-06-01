class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.3.2/apache-pulsar-2.3.2-src.tar.gz"
  sha256 "18f3681982f206c8f9ad98b5ce0cfaeae24628473d86feb9a3711682050bbbbc"

  bottle do
    cellar :any
    sha256 "736dc19da57b43355f7f12c28aad9a67522adb60797bdc31a25b0916a08cde24" => :mojave
    sha256 "8153e0793466c0a2962274a1f9a9e3a76a1a10197ee200446b10c04f4bff5082" => :high_sierra
    sha256 "c4b29df27e7bc63bb583348c3a6a2bb66f4eb62edc23df350398395fb67433c1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "protobuf"
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
