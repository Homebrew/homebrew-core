class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.1/apache-pulsar-2.4.1-src.tar.gz"
  sha256 "6fb764b0d15506884905b781cfd2f678ad6a819f2c8d60cc34f78966b4676d40"

  bottle do
    cellar :any
    sha256 "f36b8f90cd2507d22ce372eb80cfe8b8b017caeb87317bb8a19e7e72ba537fe6" => :mojave
    sha256 "f52602085cdb9b3f1a1789eb6aeea75c5f780c90ffb18935a9b7fef1e1c59c42" => :high_sierra
    sha256 "64c15908e900d3db746d7225a266867b85f00cb8402dd6ae4ce12d9dd6d6732d" => :sierra
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
