class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "28c4f39b88f095d78d653e8d4fe4581163fe96ecde5f9683933f0d82fd889a57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12f9c8683eb4445d7b7da6544b7797cdb45632546f7f3269e121cbceea5e4099"
    sha256 cellar: :any,                 arm64_sonoma:  "aeb06cbe3d7eb189bd5d241f2493edf720fa411af31c67e969a5bec85b2cff6b"
    sha256 cellar: :any,                 arm64_ventura: "5a25457da9d3aa76130870f0f197a06f78313c07df539c93a8085b2d6f2e2e8a"
    sha256 cellar: :any,                 sonoma:        "e0a6c03426183f5c676032dbbd17a607c16e9d204d2402064adfb1cb9b1ec7f6"
    sha256 cellar: :any,                 ventura:       "eaacaf0eea0f3d9cee21147a790cf58e179e1907612a56b0c0667176b2fdb1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7683caddb080720f0c2b624fd18e5ed5b73b44e500c750fdfb98fc2aa1bc63"
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
