class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp/overview"
  url "http://nongnu.askapache.com/linphone/ortp/sources/ortp-0.27.0.tar.gz"
  sha256 "eb61a833ab3ad80978d7007411240f46e9b2d1034373b9d9dfaac88c1b6ec0af"

  bottle do
    cellar :any
    sha256 "815198568711eef54dee0d427306d797c6c91597b620c2f47dcf74032ba1b37f" => :high_sierra
    sha256 "e635cdc42658919c76a04f89493eda811d3db50f2ca6c062d0fe76967caf1120" => :sierra
    sha256 "8c018f1fd1a4312a55b2d0225133956afdee4bd9a8648b84ca400d033f847ad5" => :el_capitan
    sha256 "38b9d28c30675e6cba3889386982153baf96e2375d97bcea9de10b39ff88149a" => :yosemite
    sha256 "3aeb452ad1f254803db24c96826755188820dd144bffa842dabda4d576d08595" => :mavericks
    sha256 "5b0f1247ca43018aa4473d5e887d62f3ae9c317dbd3f6962faafae028bd28fba" => :mountain_lion
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
