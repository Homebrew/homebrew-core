class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.5.22/ortp-4.5.22.tar.bz2"
  sha256 "c30fd72e7847b32b5aaa31dc5a82c92856c59ca8cb8128d50b3c0e38104d6376"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f38b7dd3e01189ff54f08af3e1816bda8a271a3b9fb881ac016c92c6d4559289"
    sha256 cellar: :any, big_sur:       "72ddf3e216f8872d3fb2c05bb5c4c5c42a634e9dacc9da2a627e635bb3df5139"
    sha256 cellar: :any, catalina:      "b32dd3be2ca41668e28358b569a45601a438ad3c27485dd3466170179bffad43"
    sha256 cellar: :any, mojave:        "744dbf510d424ea8b8a94da72cb5a0786a526007ef1c5fbe31364d60572da29e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.5.22/bctoolbox-4.5.22.tar.bz2"
    sha256 "2c659b572e909c4beac3f1e5565d3ba1565663243228b803a9ee49ff1a9b1cf4"
  end

  def install
    resource("bctoolbox").stage do
      args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
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
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
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
