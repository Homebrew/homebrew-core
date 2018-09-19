class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.7.6.tar.gz"
  sha256 "9155102243c6c7a3e9a6b37b259f7587bcfbad5f9521fbe466be58a4517df769"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "408c8ac357165254cb15e86c81ddb0b5b500a1cc29f4189a612181dcc17ea595" => :mojave
    sha256 "8808be17bde8840ef13a5ae92c34e73708917d40b9a52cbd129745f49a0ded54" => :high_sierra
    sha256 "03a83c002d6d65f611c75cde70cd5dfb8572a36b04094ed476c1054410b8df98" => :sierra
    sha256 "94a87a3c00a87c38ef56972eb11b952986a00722b2c571ec16e24ca7aff87aab" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl"

  def install
    system "cmake", ".", "-DNATS_INSTALL_PREFIX=#{prefix}",
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
