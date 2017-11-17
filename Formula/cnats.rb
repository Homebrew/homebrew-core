class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.7.4.tar.gz"
  sha256 "74ca4b380b7c5cb7ae85017d9e50aa23e89f7565f500f40df359d82adb493b93"

  bottle do
    cellar :any
    sha256 "23e7c62e63cae42c06f4c3dd55f3eb4adc6965bb0c6beefd5885e85480b80432" => :high_sierra
    sha256 "3ed29c49f6fa03f7202b2c32431539cc6ea031f2840512a01c0a4f142dc6fae1" => :sierra
    sha256 "153f4ddc7bff4f4ee5123e1e15a179a8a9295441206db51f52ab85156c2dca56" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libevent" => :optional
  depends_on "libuv" => :optional
  depends_on "openssl"

  def install
    local_cmake_args = ["-DNATS_INSTALL_PREFIX=#{prefix}", "-DBUILD_TESTING=OFF"]
    system "cmake", ".", *local_cmake_args, *std_cmake_args
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
    test_version = shell_output "./test", 0
    assert_equal version, test_version.strip
  end
end
