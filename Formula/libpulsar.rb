class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  sha256 "e1d007d140906e4e7fc2b47414d551f3c7024bd9d35c8be1bbde3078dc2bddbc"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "169f1433c214fdfa10e8808e43ed32386757d96548bf924c258b308e7c74c393"
    sha256 cellar: :any,                 arm64_monterey: "0fdbffe2f65165b26c76185a88a51fbd84e6950bf0b3a7332286ff88f0ef27ed"
    sha256 cellar: :any,                 arm64_big_sur:  "5442a5dcaae7047accf6f9b8f908acc69e80803c49388e5f20c3e6f49144d6ee"
    sha256 cellar: :any,                 ventura:        "7e155912bcc95a35ce33acff4d972ea6e59bd782adc8007dcf1d9b39a6d73bcc"
    sha256 cellar: :any,                 monterey:       "0e4e702f0f3d5ec80dad5424533beae9c74d8bcae8367a8b343e787af46a7341"
    sha256 cellar: :any,                 big_sur:        "16cd7366e60750cac6d1db34d0d3c0a20bdcf1e252108520470cdcca006c0162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e205197114ec20279a3aca87796a81b06a28bd949a44e630be5a8cff0f011c34"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_TESTS=OFF",
                    "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                    "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf@21"].include}",
                    "-DProtobuf_LIBRARIES=#{Formula["protobuf@21"].lib/shared_library("libprotobuf")}"
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

    # Protobuf include can be removed when this depends on unversioned protobuf.
    system ENV.cxx, "-std=gnu++11", "-I#{Formula["protobuf@21"].opt_include}",
                    "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
