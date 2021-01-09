class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.22/ortp-4.4.22.tar.bz2"
  sha256 "c2a58f1ecc37231499cb414fd4d5b2cdefc5b293f81db6603c9250c971646935"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 "4007e619fdf9b62f48dc6897309d600bb7bcc927d94c62d53f9438e1c946dc8e" => :big_sur
    sha256 "5ab4dc28a31243ab59862f74f5edc4d615115b539532b284ccd17a3bb8f8bbf1" => :arm64_big_sur
    sha256 "5caba650034ac5418a2dfe1d5cb26e667af555dcba655a765ed7a0e21bbdd6ba" => :catalina
    sha256 "1037969f3d5869cdde0f1ca6f3d1f8f7d3cb01c544fbcf14f913f96f29f8cf29" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.22/bctoolbox-4.4.22.tar.bz2"
    sha256 "9a26e76dbe165289992a55a89ee5e6c5c18c79d32920910e7a02c34ca8b6e1a5"
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
