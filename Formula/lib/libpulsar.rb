class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  sha256 "d24990757319dfa9c9e5d3263f60105dd9e12ddeaf1396d6b397f87dab2fd7d1"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "31235e016147dce60e42ebe38efc86ea9185b089fa78d9de807a31eaf890c333"
    sha256 cellar: :any,                 arm64_ventura:  "9954362c21d03a5556663cb277fbf632708de0782e742aa77f9570d27a63f64c"
    sha256 cellar: :any,                 arm64_monterey: "66601937942211c4300222bc06fc11a716097f5492ba4b4bdd4284d92adeb02a"
    sha256 cellar: :any,                 sonoma:         "0cdebd1de70f1577de2a2ba0c1eb34a265e5182ff22f5ef3ce10fdcb4b2cf6c1"
    sha256 cellar: :any,                 ventura:        "1d5dd1113863efb7eba46ad7d7c1ce6d0efbf83b7f56db2929a76fa8cf78b4a8"
    sha256 cellar: :any,                 monterey:       "039b0f9a03714d1eaf2f1199e9dccd9e308b0fb08467d9ec46860a4d4b5828a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dde36fec55d9ba93066e26274048c3776f88840c5a29c241609ab029a3b0ab6"
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
