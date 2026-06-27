class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "f6ec9ee2ab367594b56dd3265e3561074ade7c3d7410a6f45a77704c5e537024"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "22e12ff22d295f76e6d68850e64eec5e912d6483cd358d9cb16d9216b7191ffd"
    sha256 cellar: :any, arm64_sequoia: "ea5886d7778bf262d28dd5cac8c1b7c1f8ab9ee826b95299ffce8b5260908c1d"
    sha256 cellar: :any, arm64_sonoma:  "e0802d0c00e642ce1f18b502e1e243bc1aa7ee518663888e2071383fc0ddbdcb"
    sha256 cellar: :any, sonoma:        "82d9e9f13cc53c0f368e94ce14d6741b581b506375898583617d1e25f9a9a3a0"
    sha256 cellar: :any, arm64_linux:   "31330dc0d04e95e195bbb1ee9038d645c2c9222d8740099d0e896cc48df198f9"
    sha256 cellar: :any, x86_64_linux:  "ba7aa71b4c62aedb7b998fdb73055f0f28739b21529b870891ff0c9324699be1"
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
