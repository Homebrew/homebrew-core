class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.0/ortp-4.4.0.tar.bz2"
  sha256 "9d939ee57161cf3060e1b3fe11060e5dd1f1575939e62974ca5ae7f959ebe881"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 "942d93781ca52a133ae19952fb044a6b02060cff30177a8525ab2a5e4a0991d4" => :catalina
    sha256 "231dc8ca885b103e360e347498277f41c2fc0d446420b8c1324e00e301a8eedd" => :mojave
    sha256 "ea6fc0e9626908e8a62b22cc86a2f87d513716c2091cfa52bac39c5c9c7a5d79" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.0/bctoolbox-4.4.0.tar.bz2"
    sha256 "d0efabb579d02f0fdff319a047eb487943edb5761d4b872f16762b4b4ef40d62"
  end

  def install
    resource("bctoolbox").stage do
      args = std_cmake_args + %W[
        -DCMAKE_INSTALL_PREFIX=#{libexec}
        -DENABLE_TESTS_COMPONENT=OFF
      ]
      system "cmake", ".", *args
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
