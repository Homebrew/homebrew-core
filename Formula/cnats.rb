class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.1.1.tar.gz"
  sha256 "40f72e9b66b44649c4caf0d06e8c4968c3a0ed93c87b48195a0c8c53f8f41c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c323dc4b67b6be0935261b219e5d7df6e0c4edc0d0f1ba95712b01444b9b1ec8"
    sha256 cellar: :any,                 big_sur:       "0abc72625ac20c93a5182bd9622ea19ee8af6ae450f376bd3cb45f305b4716fd"
    sha256 cellar: :any,                 catalina:      "419b322198499d8b1ffed3c5cd87fa87be74e7c3bd1e29e574e102949752d8c9"
    sha256 cellar: :any,                 mojave:        "c9709913ab2edbde24ffc9bbe43fe9738677bcd7f3584dc5ff54b6a9fea92235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9b25a5cc161b32f24c8d6798f9f0c506b4b59ca8e7e36a6f3aff61c8861de79"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
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
