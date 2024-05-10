class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  sha256 "d24990757319dfa9c9e5d3263f60105dd9e12ddeaf1396d6b397f87dab2fd7d1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fff111a7b587706434cab7912abad51ce873fa2ea2dda118f5935b244cd4963"
    sha256 cellar: :any,                 arm64_ventura:  "d269e47fe644c6610b7f889dbc0349a52eae2a4539498dac248b73050bc73195"
    sha256 cellar: :any,                 arm64_monterey: "b17867e7525e48fc192dd2405daa135d35c70fec6e13e50953fb77355cd2cdc5"
    sha256 cellar: :any,                 sonoma:         "ae47fbc2f5e85f1fcfc53d9f7334663230b8e5188b144b480e83c7dbed8a0d92"
    sha256 cellar: :any,                 ventura:        "d159bf901ff1d4855d7bda034b744462751543d138f1da83feb0e1fdeef04223"
    sha256 cellar: :any,                 monterey:       "e0337b7fc58357c45f72843a2767c5e96f60704614545d71dfc77f8c3102b7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf3f1bd4618b31ed18a970964638271218d00f302d87dd9d8ededff297af0d0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

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
