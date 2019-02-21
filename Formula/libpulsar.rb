class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.3.0/apache-pulsar-2.3.0-src.tar.gz"
  sha256 "ac182c83f2fff03e8242cb9f9540d5ae2a32e3b9b382a2340f139dfa0bfb0a28"

  bottle do
    cellar :any
    sha256 "5ad00ae41e7e75b95e3d7aedebb3926d3a047a12a6aefc52bc747ce560582df2" => :mojave
    sha256 "af052cedcf7f38de93ea47897d2fb7ae82ae3442338ed622838a4c4208fafcde" => :high_sierra
    sha256 "5dce47989a8d0c99840a6385e939de39a3f905d4ad64edd2c8da73eb12e78e75" => :sierra
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
