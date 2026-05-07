class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "06b64d7045fd618c98e5608001b384bdbfa6a17718dba64e732ba72a6f00649b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7112434cd21aea4f66a5d40b2be3df44bd766af00c927c31effcbd231ed74455"
    sha256 cellar: :any,                 arm64_sequoia: "4981e38ca26b18b2aa389208b48f4d7952c4d3a5ac47821554e56a2e52d5e00c"
    sha256 cellar: :any,                 arm64_sonoma:  "18493a3f33204a6900e359ebd36536e71797331ec508dd459fafa8f13590a5db"
    sha256 cellar: :any,                 sonoma:        "69eb294ebb1b670be5cecd720f408a35cad8168701ce247d782a3bd9ca37191e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc62cff7a81bba4164f59fa7bddaf318a9f71ed5c94a4b48db2f7279289a80c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3ad544ee19cfe6048497c56f7c0a5fc6282e6c65d854577dbd277016120db4"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@4"
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
