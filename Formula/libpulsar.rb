class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.6.1/apache-pulsar-2.6.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.6.1/apache-pulsar-2.6.1-src.tar.gz"
  sha256 "7e40f95c2eef295bacae70697d452a4db4994725e1fbbde011df1ee383ef21a4"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "84dcade994d3c66847651c5ff4acfa42522fb39c815b289d6a52a9f37960831e" => :catalina
    sha256 "d2ffc07fdf4c8ed73facfdc2767b022b040b52a35eb0c337d38fc11854b2dbea" => :mojave
    sha256 "65a411e4177cea90299be10b6abebb3a45046cb52f7641854aa7aeab22a10268" => :high_sierra
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
