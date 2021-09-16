class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.9.1/apache-pulsar-2.9.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.9.1/apache-pulsar-2.9.1-src.tar.gz"
  sha256 "e219a0b38645c64888ec031516afab0ca3248c194aaaf7bdc1d08aff4537e1f9"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "560f3649ed47b674cee37b48f578f594581a67b22d8da5c8c50acb4a74314166"
    sha256 cellar: :any,                 arm64_big_sur:  "9bf2c9af3f6b3374f0e4efd8aa4598cbf5d8fc5a3c0bd2a7762de0fe4515f20b"
    sha256 cellar: :any,                 monterey:       "2c22c0156a621b7348026420a996bc4878627a922f14a6c64c050ce6ae9f7418"
    sha256 cellar: :any,                 big_sur:        "56dd6a3ca53194b5ec8b787b9ff29e0a0a4f8af3ffc4b642773d318c8cd48959"
    sha256 cellar: :any,                 catalina:       "75dbc70d58a0b5ee8af17e93a6ddb6459902680574527aeac4b03ed3fd4c3332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59eab1b87d05d294489dc87ea61a9528778a877687197f2050ea5bd37f0ccd0e"
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
