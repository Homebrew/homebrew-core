class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.0/apache-pulsar-2.7.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.0/apache-pulsar-2.7.0-src.tar.gz"
  sha256 "f1e8168b7f2b8bfc06c84f743eb4f3dfa5f8f376f087c5ef1532f998cf56bab4"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "05f224f799cc8a8eb1407ff60cc561413b441cb46a603ce7547c8659ab1e9703" => :big_sur
    sha256 "c5b12dbbe3af5397c3dd6c4c9d7fd34df9fc0be9438dd94b479cd892af955ee8" => :catalina
    sha256 "964a2f24bb0f57621c8ef283a5e2550ba9b31166d167061a0f15d5ad88383523" => :mojave
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
