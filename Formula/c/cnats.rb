class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "9ee45cd502a49dbd29bed491286a4926e5e53f14a8aacad413c0cf4a057abee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cea1673189ed951c74e4220e22362fee2c6875f741312f6fab6ae90abfa9771"
    sha256 cellar: :any,                 arm64_sequoia: "7866177a01aa325578321f2e60d64c485220dd462fdd266d07edcc4d2752f115"
    sha256 cellar: :any,                 arm64_sonoma:  "041326a64ef5f7c2c22dc50d30e445fd54bd5b6d3cb529dafc81317a28270bc7"
    sha256 cellar: :any,                 sonoma:        "025ea609d4ad1513a2ee6ab2130123fdeeb0e16006072c84b63735c8678f3e53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c063627a562b5f5965a08c358ef8e21fe8dcdc5b049252165506eb98246ad47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "092bae28e028eda4a513dfda93c4976b17e297ae036ee473a47732b37126cb3a"
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
