class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "1f8b450bc295d0c94be201e34713ca0b515aae2c0d1b279273c3e6e0e72fe005"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d292cae09692a23470f2979184e8f7d65cded4099ab1b296d33c1ad86e53d438"
    sha256 cellar: :any, arm64_tahoe:       "0183f643903a67f0315b31e2171d3a3cbf67d9a83866267a2f876f50464a847b"
    sha256 cellar: :any, arm64_sequoia:     "8c319f01345442e649e939c6659bf0cf66e1ebba5a447e24c966aca2fb142344"
    sha256 cellar: :any, arm64_linux:       "6a07a305c20a94cf16b8db8d9576aaaa0156f9d07f9c38bddccdcbb2f17f2fc5"
    sha256 cellar: :any, x86_64_linux:      "9a6d507ada1dc34a77eca2ee9af7d4b089a709b4695d1a0b6149abdc4c4b2b21"
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
