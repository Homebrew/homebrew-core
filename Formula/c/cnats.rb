class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "06b64d7045fd618c98e5608001b384bdbfa6a17718dba64e732ba72a6f00649b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6b6a71f904ece5d05e820a00279676169c201dd29af015760f14ec90eedf6c3"
    sha256 cellar: :any,                 arm64_sequoia: "4802784048ccef88363702e5db80b98657daa8dd7ebd90d545535329c516de18"
    sha256 cellar: :any,                 arm64_sonoma:  "f693d5fc84ab27feef7ef4d67b8674a88f36f42a05039ced84312f5a065d6ef2"
    sha256 cellar: :any,                 sonoma:        "da0021e25b526acac1a1e0d4f6fbed9aae416f2986f4b000b31b1b80b72741b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f811f0043da5c8aa249aa337e7a983fa76c8e82eb1f5f99c88934551ebfb3882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1891557d88308406f2cb6525cd9825777c4bc280becc0b68878d471a82f9c2b5"
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
