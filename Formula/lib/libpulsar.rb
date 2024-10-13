class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  sha256 "522ca67bc911fcd4c0c9e4278628c9167b614a887c63fb04b04370156254d3b3"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8210f8a3373fb2b6945a0c802ad15b4807c0f879363ba6d654fd1699370d119"
    sha256 cellar: :any,                 arm64_sonoma:  "4881994c4a1ec4cf2fcc48c054b952d5b65e1aa5986c7b01d0681fcf801c28e0"
    sha256 cellar: :any,                 arm64_ventura: "2635d4dc5cc99c80a64504f8383fd00ca3a4e55bf0e75a1bb39933ecc3a291c7"
    sha256 cellar: :any,                 sonoma:        "4add86889b3a6e33ee81c5b689fef73faa3a8cddf37988a36d38b23bb779f83e"
    sha256 cellar: :any,                 ventura:       "23ff6c9bcc4061400cdb805710203028149c1713ea7703a916c7881fa38141af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ccc5a9a3d782096150522012bb1c930622ef1b23f08f0b2df974d6b0254cb89"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "boost"
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
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
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
