class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.5.0/apache-pulsar-2.5.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.5.0/apache-pulsar-2.5.0-src.tar.gz"
  sha256 "87ffe8aa9456d1143e2436f83d3ba220f12246a90f03c6b51ed5dad0df489a3b"

  bottle do
    cellar :any
    sha256 "ad91738dd0677d31cfe7a87f759e170d40a45792cc81912ce318ca5f3bc71471" => :catalina
    sha256 "d4be8b7fa676375fa31d74d85f4aea290858226bb3dae10f57f5b03447a35093" => :mojave
    sha256 "c7b65b329b9d018e5aa373078a4a437b7d530dd87e34d30858d122c52e308027" => :high_sierra
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
