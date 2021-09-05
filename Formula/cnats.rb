class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.1.1.tar.gz"
  sha256 "40f72e9b66b44649c4caf0d06e8c4968c3a0ed93c87b48195a0c8c53f8f41c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b9f4dceef021074200dcb293db3e6e54f2f733285230e2681f8bd2677bf08e21"
    sha256 cellar: :any,                 big_sur:       "c075c0e67fea4892dbd61f8c6fc8e2406f7a19a218a079c127a4c2591fefc8e2"
    sha256 cellar: :any,                 catalina:      "af6f6579381e56607adcba14953b4041d2e66307ab5d0331430f284c1164d15f"
    sha256 cellar: :any,                 mojave:        "f34815c002c689fe110792f10316d2afe9c1e914c2efefdc220753d4e1913660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8da9b9ed78b44a8b5789adbd305ff441114d28d12963483f9346e44366446c1"
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
