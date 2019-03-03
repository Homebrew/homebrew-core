class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.3.0/apache-pulsar-2.3.0-src.tar.gz"
  sha256 "ac182c83f2fff03e8242cb9f9540d5ae2a32e3b9b382a2340f139dfa0bfb0a28"
  revision 1

  bottle do
    cellar :any
    sha256 "1ea444db8f1603b6116589b1f9824e0fb17b7b7b4f7067ef84f3c921ffc50c63" => :mojave
    sha256 "ffb1c9d31e41a6bcf620ac12fa439f6c9ea404800bb1699a0daf09e7dd282a30" => :high_sierra
    sha256 "55bf7a833798d77746bf22fed057e9584eb18c916ef93a45b888440bcef976c6" => :sierra
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
