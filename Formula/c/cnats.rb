class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "465811380cdc6eab3304e40536d03f99977a69c0e56fcf566000c29dd075e4dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13142ae064870e4d1aa55100c189587168328402ac75f7c9753cdf210c2e74d4"
    sha256 cellar: :any,                 arm64_ventura:  "947d31d16d7489328169ebf365f50cc78337cf6cac62ed4899e4229710c83fe0"
    sha256 cellar: :any,                 arm64_monterey: "3e94f005ba81ce781ddbc7cb9c783763d0032ae29b9ade35a374982aedc41241"
    sha256 cellar: :any,                 sonoma:         "1984bb01930159df454e79f89f21930def293360c0fb60fad3a3bb50980ac9f3"
    sha256 cellar: :any,                 ventura:        "610d750a44981068ab4c8913608c7ba8bb9ffab6cc492b8a32f189734c3cef7e"
    sha256 cellar: :any,                 monterey:       "a14599f489c88a0702ebf96eb0e3ff62ccf7cdffb00bfe545983dac0f406c0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b8391012e32cb1bcd132de9c60325ce55b1c197c2db46660099609e3286bca"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
