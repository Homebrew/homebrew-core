class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "1765533bbc1270ab7c89e3481b4778db7d1e7b4db2fa906b6602cd5c02846222"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "311bab357bd42525c9091898188dd7f31affbe0181281a7f8d1f4c04f1060283"
    sha256 cellar: :any,                 arm64_sonoma:  "e10e38c7ac7967776360767a9c7631f0ea32d33078b9ef5c40172af54101c24c"
    sha256 cellar: :any,                 arm64_ventura: "a53d7f08299d8fd16c00e7920413c994332af53cceba4fbc7bdb16f82f69646d"
    sha256 cellar: :any,                 sonoma:        "2cced9c96fa88e2775c71596927403ac5022830e83bce66706ee928257876b0c"
    sha256 cellar: :any,                 ventura:       "e3f29e14fd84d143e79a2614600aef8b3adf194fda8aa4024fc337337eaa81d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "240af50bcf075ead0506a2a120c431ea2b2c6c3c3a923b60c8d3003d611092bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98abfc0b03a47a9c8d9884c4f68a236af40a2be2e42ac8e414f6b9211646e887"
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
