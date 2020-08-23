class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.3.2/ortp-4.3.2.tar.bz2"
  sha256 "1796a7faaaced1278fae55657686e7b9fee66ca4d9dabd8f1c83f21957fc002b"
  license "GPL-3.0"
  revision 1
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 "30e7de767fb902fdcd4862cc6416c00997610f1313d628b81913faa9445ed137" => :catalina
    sha256 "cdd8f113bd135118b9784995c19f6585d7a5810fdc8ae01cd008e59f90da2adb" => :mojave
    sha256 "9a18cf7d3e0e027a1f6a2135f86ca89c504c8aa5090203b63552b228c7ac6f96" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.3.1/bctoolbox-4.3.1.tar.bz2"
    sha256 "1b7ec1a7fa2af2a6741ebda7602c82996752aa46fb17d6c9ddb2ed0846872384"
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
