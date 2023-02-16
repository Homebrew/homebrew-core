class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.1.2/apache-pulsar-client-cpp-3.1.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.1.2/apache-pulsar-client-cpp-3.1.2.tar.gz"
  sha256 "371a34a61930374bd8a1e503ef556e740354e7ccb59ef2a4fe8e499fa4974423"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9863180249e1f97fe171c519407b6af5abe7046c725e2eab874f1aecd1d08373"
    sha256 cellar: :any,                 arm64_monterey: "840dfd9306a8dcca863c59b1245475b3f4bb8ca20dfd0917e15ce6debea9df4b"
    sha256 cellar: :any,                 arm64_big_sur:  "00e0bd1d35af6afb9fa1784bf14b16c57059049c8c96246010c8806b4aae91dc"
    sha256 cellar: :any,                 ventura:        "094661bc41395c5866c74afe0d93b0fc4a2fea151233e46eb183b09445258580"
    sha256 cellar: :any,                 monterey:       "aceca458d29925ad422dd14bd5eb147c15e0dd9d80129680da90c3810eee8ea5"
    sha256 cellar: :any,                 big_sur:        "312eb31ec86272cb6097938f0d7d7561ba91b768da8ea93aa5b0413407046f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d4a001934fb112114a68ba09944eb401d95c03d974f2a49009f2a9f97bccbb"
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
