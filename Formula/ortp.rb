class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.3.2/ortp-4.3.2.tar.bz2"
  sha256 "1796a7faaaced1278fae55657686e7b9fee66ca4d9dabd8f1c83f21957fc002b"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 "f49949830b4e6f09bb69c81ff2e2f8f3653bae1d648bc57db393bb92195fc260" => :catalina
    sha256 "1659170fed5ce087fe92e8bca8f8666ce1a2573220897df535a035582b8bd45b" => :mojave
    sha256 "183386b78f9bb94670265af5b717b604d678b399517e7ee9848b6999209755e6" => :high_sierra
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
