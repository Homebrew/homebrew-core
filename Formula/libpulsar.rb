class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.0/apache-pulsar-2.4.0-src.tar.gz"
  sha256 "b4666cade20f7e7c01b9050813a3975d4e0fba36f0ab058e39e41b30e029dc05"
  revision 2

  bottle do
    cellar :any
    sha256 "caf6afe837d6f6c5c12bf8a151733c538792160cf859422f6f9438b9bb1cf582" => :mojave
    sha256 "7bb8fcabdcea63038d5c2428f9a40e479fd188fc024641c990ca9c5ffaafb968" => :high_sierra
    sha256 "117ff4ae42dcc8ba857e67cdf60b8c2c70c637d7b107a70628c0701d2e5d0810" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "zstd"

  def install
    cd "pulsar-client-cpp" do
      # Stop opportunistic linking to snappy
      # Broken in 2.4.0
      inreplace "CMakeLists.txt",
                "HAS_SNAPPY 1",
                "HAS_SNAPPY 0"

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
