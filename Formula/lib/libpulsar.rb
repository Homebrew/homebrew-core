class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  sha256 "522ca67bc911fcd4c0c9e4278628c9167b614a887c63fb04b04370156254d3b3"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "468bc0a10d09af644373267ea8ccfbf6b7dcb713387066463b1e238c7c23c8e8"
    sha256 cellar: :any,                 arm64_sonoma:  "7cae206357ff508ecd30a70cc7b101ec62ae375fe4172d2edd2cd8178885029e"
    sha256 cellar: :any,                 arm64_ventura: "001f8e40d0fb10f830e27ad4252ff4e70d2bb046aa0283901a6d54a741a3fa40"
    sha256 cellar: :any,                 sonoma:        "df1736d28bfa1885786ccd5db1e6b3af61120d454ac88a38ea5a56d36d030eb3"
    sha256 cellar: :any,                 ventura:       "3d4f7bb72784cd82cca42f49d95f371c1c1b54bd01614554dc13e3ee4fe0afc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e2e1032d9b5ae9aa365fca6e075c0d91cc4fed3cef6ce0d52d5d427c3c06d29"
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
