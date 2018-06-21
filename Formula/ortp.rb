class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp/overview"
  url "http://nongnu.askapache.com/linphone/ortp/sources/ortp-0.27.0.tar.gz"
  sha256 "eb61a833ab3ad80978d7007411240f46e9b2d1034373b9d9dfaac88c1b6ec0af"
  revision 3

  bottle do
    sha256 "e3a51b196a5df3f631c257348a977925231ebca55511b32f35e2da4852b8e69c" => :high_sierra
    sha256 "abcb87f456d528c5ba4a8fdaee206ce7e9d32ea4505b792cc2beaf4f010b01ca" => :sierra
    sha256 "09a70f1865222aabc8c0c3c68c45f7d6589f6f6d0cdf9891d81ba5ed77961964" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  resource "bctoolbox" do
    url "https://github.com/BelledonneCommunications/bctoolbox/archive/0.6.0.tar.gz"
    sha256 "299dedcf8f1edea79964314504f0d24e97cdf24a289896fc09bc69c38eb9f9be"
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

    libbctoolbox = (libexec/"lib/libbctoolbox.dylib").readlink
    MachO::Tools.change_dylib_id("#{libexec}/lib/libbctoolbox.dylib",
                                 "#{libexec}/lib/#{libbctoolbox}")

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
