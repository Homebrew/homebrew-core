class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.12/ortp-4.4.12.tar.bz2"
  sha256 "d394fec3939abdd8506d1d1aed43dd86697ea5582e73489c2896c3f3f781fe62"
  license "GPL-3.0"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 "f5616400b51ac3c1ab3ae0c6041172b2e9f89dce861c556a8324007576d814fc" => :big_sur
    sha256 "30e7de767fb902fdcd4862cc6416c00997610f1313d628b81913faa9445ed137" => :catalina
    sha256 "cdd8f113bd135118b9784995c19f6585d7a5810fdc8ae01cd008e59f90da2adb" => :mojave
    sha256 "9a18cf7d3e0e027a1f6a2135f86ca89c504c8aa5090203b63552b228c7ac6f96" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.12/bctoolbox-4.4.12.tar.bz2"
    sha256 "8d7c797af45d2e1c7f4f4c345307af842b34390112cbadef28491d5cf841ca83"
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
