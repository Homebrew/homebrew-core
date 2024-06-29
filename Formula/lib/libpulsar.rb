class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  sha256 "d24990757319dfa9c9e5d3263f60105dd9e12ddeaf1396d6b397f87dab2fd7d1"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c3977514cf6edca99fbd871ade8e6f39a20fb370839f60a399e7dca18d3bcd71"
    sha256 cellar: :any,                 arm64_ventura:  "6180325b2bdac7c4d5d82c00ed19b30967b966de1b0cbae4bc71206d0c6ac872"
    sha256 cellar: :any,                 arm64_monterey: "c96e48429050dbfedcade7225b9ad038016c18ea6b044fe1cb79f14c8261eb16"
    sha256 cellar: :any,                 sonoma:         "7c2f2cda4965a2c6fd83c8766ffff2b405d21cbec1d0befb5c73a104259589b2"
    sha256 cellar: :any,                 ventura:        "cb6b6ca1d7a04509da589ea1d09c4a9bf17f946e457b5c1a3df41f84caa7831f"
    sha256 cellar: :any,                 monterey:       "b38fcff8f422942b6658224106858ce46eeb894f2dc74c74732350e100491dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407806381a142f65595d215b35dbd7564cc901bbcfc5a500f1a9d89295b34d5e"
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
