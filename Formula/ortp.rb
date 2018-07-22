class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp/overview"
  url "https://nongnu.askapache.com/linphone/ortp/sources/ortp-0.27.0.tar.gz"
  sha256 "eb61a833ab3ad80978d7007411240f46e9b2d1034373b9d9dfaac88c1b6ec0af"
  revision 3

  bottle do
    sha256 "29ed10dcce917af7edef44a75ff57ddc13d8b7d1c6e1495b4316dd3ff9a19da4" => :high_sierra
    sha256 "25d22aed8eb680d38e3b1ad9665a16923a8e602bf1425a7f52138e2f5a534a95" => :sierra
    sha256 "fee93f3d2e3a72616d1718b1211c0828442635d0433ae89bde6567adeea98038" => :el_capitan
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
