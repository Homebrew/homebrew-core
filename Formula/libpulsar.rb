class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.5.2/apache-pulsar-2.5.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.5.2/apache-pulsar-2.5.2-src.tar.gz"
  sha256 "3903ec6a396833096e82ba8867b101dc5e907f94fb0ffecee9fa802c4ad4732f"

  bottle do
    cellar :any
    sha256 "780d9a0a1541ee024bfe219da3436c8dbdd00e4fbf51789160731add419b551a" => :catalina
    sha256 "28e5d1be4c8b5fdfde5b565d354765a5c07ab0d3b79a8b66d5a249bba9c2923b" => :mojave
    sha256 "d488ba79662d21832e9d8a6f7b0e246ffd0951f43548bb50554ab6c443815caa" => :high_sierra
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
