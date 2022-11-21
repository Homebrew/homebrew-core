class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.10.2/apache-pulsar-2.10.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.10.2/apache-pulsar-2.10.2-src.tar.gz"
  sha256 "20e367b120db9d7daacfe5f26b4b5a1d84958933a2448dfa01f731998ddd369a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "905e693415f1579ab386fd04827c04d8623b38a1270570e16db7341991d3ba99"
    sha256 cellar: :any,                 arm64_monterey: "7684502a076c38f73c157a5e1c1d2487872ddab8bf2fc9571d31dade41e7e5b3"
    sha256 cellar: :any,                 arm64_big_sur:  "d9cea1b23580663097fc1a33be9673bfd47780e0ac6c2d12ad8b58231901a2bd"
    sha256 cellar: :any,                 ventura:        "f93a1789818aa9327a7aec4d5e40f40a6b56ee8ffd796014857f8a97b8c095dd"
    sha256 cellar: :any,                 monterey:       "26e0535689cfc7b6104b416cb4b2d303d3cd477860dfacc8606af1a7dde78dd4"
    sha256 cellar: :any,                 big_sur:        "dcc63503ddffdf7a90d1caacff4f8bbd5546514751bdaf59fbc442d4a49f7cd4"
    sha256 cellar: :any,                 catalina:       "fc406b86e64b34cf971ffec37528e8956329930550ca78a0a1dcf91ead9d14dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c061facf327e271b579e843d5a98cf81508bdecbcefec4a54a6a04d5965e0e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

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

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
