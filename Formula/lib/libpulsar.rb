class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.0/apache-pulsar-client-cpp-3.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.0/apache-pulsar-client-cpp-3.7.0.tar.gz"
  sha256 "3223cfeda484ab7b580f4a8768b5a85739cc064005c765c06cde67c3238639c9"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2762cb88dd01d626ab6dd265e2264b195133c4874b82f189ea8001a918869c7b"
    sha256 cellar: :any,                 arm64_sonoma:  "34bf8ce2ebbc5f95e33a1dc572e8f08927e8c1adb14bcb68e18b30e978baf6d6"
    sha256 cellar: :any,                 arm64_ventura: "2aa84c52798c6a67d233b56df26029742569b882c6cca6907cbc7ab46283f3f1"
    sha256 cellar: :any,                 sonoma:        "28e17003491d94d95f5330fa8345aaea561dd9a021f30fdad0068246faf1e4b5"
    sha256 cellar: :any,                 ventura:       "b734145006bc1f4cf5697518cd9dec720c42ba7743c6d6f8e21721bc14fede9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcca0ff004a931852586876682e27da0345e55fea30a522c50772a15bef394f1"
  end

  depends_on "asio" => :build # FIXME: Not compatible with Boost.Asio 1.87+
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=ON
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
