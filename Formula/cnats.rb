class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.0.0.tar.gz"
  sha256 "e10beeb623fc5dadd0673269674331f7b35d19e52ff32d14ceac981b3c701587"
  revision 1

  bottle do
    cellar :any
    sha256 "2a63067238faa20a7871b556efc943477d6274893b1878d05c34528bd5654edb" => :mojave
    sha256 "3290deb15140ce507d3f80c3d063819de70b50414f000348f9db8c57ef688293" => :high_sierra
    sha256 "6f40330287323041eac21154d2501ef0fc942cb5ef64308e242378b2f0911859" => :sierra
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
