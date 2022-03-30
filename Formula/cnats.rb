class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "16e700d912034faefb235a955bd920cfe4d449a260d0371b9694d722eb617ae1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "847dfdb3324dae6a6452a9155b69aab20587c7a45cf0073dfd50be3de6b89aa5"
    sha256 cellar: :any,                 arm64_big_sur:  "f5a30d8c0daff2dbd95f84abd3d776832020aebc0e9f72fd2afaec9276b52783"
    sha256 cellar: :any,                 monterey:       "bba0d7868221e0330d9dbbd143799b6c00a9ff61c7df4da6c958c991781b7cc3"
    sha256 cellar: :any,                 big_sur:        "1ea56afadea04ddab2a54c1025324aa21996870faf12932b519592421abaf6f6"
    sha256 cellar: :any,                 catalina:       "c905b8f2e19e74722dac91b2cb9ae290f39ec1c9cee32bb5bb0ae2e5fe723ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6146ea64138a2c7acc40881e4498cc3803564b0cc45ba97d4fdcf720fa75fe3c"
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
