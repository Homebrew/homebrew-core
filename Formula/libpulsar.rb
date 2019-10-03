class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.1/apache-pulsar-2.4.1-src.tar.gz"
  sha256 "6fb764b0d15506884905b781cfd2f678ad6a819f2c8d60cc34f78966b4676d40"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "717280405dfd245f31aa7ca617cb30fe194d581f10b6982b25009e770866ca2e" => :mojave
    sha256 "ebf1cfff1fdf2008ed08ede59ad7fc6d43f537f53363af8f642cb787fc9db61a" => :high_sierra
    sha256 "10de3eba0484613c118daa58abd18dbe0eaf423bce9b7d9a78731283ed234d40" => :sierra
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
