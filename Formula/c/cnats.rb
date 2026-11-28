class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "aed133ecf121b0ec454c9d28d34edab41898f56a67dacce09a1a645e84c0edfe"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "b4f65382f4c6c17314458fc569932bfa57478535acdc56bc9e84a583924b95f8"
    sha256 cellar: :any, arm64_golden_gate: "03553a33c9c4f71973c0ef22828a52d5f16fc12d076381d86e0e52a260b8a857"
    sha256 cellar: :any, arm64_tahoe:       "0a97b25b97e436acfcf9a4871065fafc45cbc9e5c0a5248a5be387d59855886a"
    sha256 cellar: :any, arm64_sequoia:     "c1f700de6a926235f9597a78a7a6bd9eb97acb48a02a2e716577dec1fcc7cb2f"
    sha256 cellar: :any, arm64_linux:       "f8b4415dd659feb293fea6c29c8cb236ff530052aa0653e03e0988f97e2bfe56"
    sha256 cellar: :any, x86_64_linux:      "fac1343cb372c7fb776e200bbf3b2b0626cbe6c22c966796a1c07df33f461da2"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@4"
  depends_on "protobuf-c"

  deny_network_access!

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
