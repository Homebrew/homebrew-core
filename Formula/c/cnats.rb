class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "1f8b450bc295d0c94be201e34713ca0b515aae2c0d1b279273c3e6e0e72fe005"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c0b48c772a713bf986e7c0ed1b8c4d95dcb5c775034d37537026812d6dff0d34"
    sha256 cellar: :any, arm64_tahoe:       "b12e05c399c776e78a6b088aad44019cf55eee0c27f250c96bfb34e5eaa681b7"
    sha256 cellar: :any, arm64_sequoia:     "453efb871697b97b47c507332fd4f187d94af33ac88e9269af5729ba5b29818d"
    sha256 cellar: :any, arm64_linux:       "7b35686110c20daf884ae3a3f73892f03f0df14fbf757c6971c0c3d0ac7d31bc"
    sha256 cellar: :any, x86_64_linux:      "66e637912b64ecbc22701a8e8d12765bb43beef917623579f4c7e9bf394f6839"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
