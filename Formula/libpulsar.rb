class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.1/apache-pulsar-2.4.1-src.tar.gz"
  sha256 "6fb764b0d15506884905b781cfd2f678ad6a819f2c8d60cc34f78966b4676d40"
  revision 1

  bottle do
    cellar :any
    sha256 "5512ea72365cd415f5ae87ac87a22a2dc29b4f26fcef90417aba2c5274a674f7" => :catalina
    sha256 "16712826987ae1daf5c87afde07b1f064a9915f2cc955b65cdef4b02d95528b5" => :mojave
    sha256 "87595a0547694e1e02b838b29d4522a77f403807642f7898a1bfb8db7c96d64e" => :high_sierra
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
      # (Snappy was broken in 2.4.0 - could be added now)
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
