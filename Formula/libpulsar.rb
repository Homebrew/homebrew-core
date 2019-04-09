class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.3.0/apache-pulsar-2.3.0-src.tar.gz"
  sha256 "ac182c83f2fff03e8242cb9f9540d5ae2a32e3b9b382a2340f139dfa0bfb0a28"
  revision 2

  bottle do
    cellar :any
    sha256 "4f4a0f80acd2be124172bb0667da8ff3b26a6a94320c2b59714af39665fd870a" => :mojave
    sha256 "ce4426388c88d059802fdf7976c7a4e13fbfd62fa8ab310435fbff3b270a0df0" => :high_sierra
    sha256 "bcf540fa7a12f291ed4e59476dc3288cda6a65d381d5348303e2640053a576c7" => :sierra
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
