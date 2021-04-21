class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.5.7/ortp-4.5.7.tar.bz2"
  sha256 "a7eb7a90f93eb75faede304aa64e8239fe01b3358c0d7371f26d5cd9a1687a02"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "9897c0633ff6ee1e68cd87ddd76142c31c384580c2c4bdf5d3c0036e086cd378"
    sha256 big_sur:       "f530641ce5b15fdef4acfdb9f35b3bf4a39842c516b127815b8279f233d7e943"
    sha256 catalina:      "46a3174d6ff4b0e064c79ff290736605d2cd290823ac247add63184f50138e37"
    sha256 mojave:        "78e74f94127a65a6d2221f3026e34afccb0bb59a8f21b9dc4c155acbc33c34fc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.5.7/bctoolbox-4.5.7.tar.bz2"
    sha256 "2f2a26f64851732f2af5e4871539431d75c93888142255068661bcbc6cea96d6"
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
