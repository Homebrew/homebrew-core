class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.6.1/apache-pulsar-2.6.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.6.1/apache-pulsar-2.6.1-src.tar.gz"
  sha256 "7e40f95c2eef295bacae70697d452a4db4994725e1fbbde011df1ee383ef21a4"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "5273978a7870aa73af472ade5594696e487b1ed9a7c4bf8a76ef03f33cdea177" => :catalina
    sha256 "25e2dcd6423a4c365a41dda1c5c7f97131c33997b5f498e4cc2a3c45b0527bed" => :mojave
    sha256 "5bf06bfcf53965d231e54a05be4830b502125620c1ac46451e6f41d4d3394272" => :high_sierra
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
