class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.1.1/apache-pulsar-client-cpp-3.1.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.1.1/apache-pulsar-client-cpp-3.1.1.tar.gz"
  sha256 "5563bf3c2ac2efe379c81b55b2637062ffae13d5d5a876503e84d815c922ce31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40c882e122e2653488b6da665ef1501f85b1d9091ba0a338eedcacb397601b74"
    sha256 cellar: :any,                 arm64_monterey: "96998b49377f24cb5bbd8476123969f8ae2e660ad432094e9b6d145294570e8d"
    sha256 cellar: :any,                 arm64_big_sur:  "11ec8a6a9eafe96a9608b6bf535eb25583ced37e2d604143033cc71bf11bc9c3"
    sha256 cellar: :any,                 ventura:        "8afb4b6f73c88f461dfc2f9e639dcab3e827283eb19acf76df60d7a55b693e58"
    sha256 cellar: :any,                 monterey:       "570952f0a8966d2e5ce267fa408991afd993e7e21f8b06f0d145d4ecf7db486a"
    sha256 cellar: :any,                 big_sur:        "a2840f48dbe7963bf1a31e1b8a0b4154071ac85251df6f311f9131f044e09d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3340740d78c604ea93f812741234768881bcba4eef87926ed03281acb0b768"
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
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_TESTS=OFF",
                    "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                    "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                    "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib/shared_library("libprotobuf")}"
    system "make", "pulsarShared", "pulsarStatic"
    system "make", "install"
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
