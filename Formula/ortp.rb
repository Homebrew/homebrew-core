class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.13/ortp-5.0.13.tar.bz2"
  sha256 "b73a4874e16537d5742b3107e3a69b0987096c8ddb98047549dcca8f46d5f6aa"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c01a2ab8a29df40930f2a43cec06297a5f8da07eb76192e2555f6fcd34406bde"
    sha256 cellar: :any, big_sur:       "e9a7b45cbd9418614bfc20861fe28a23538f1ba984824fc28598de4f90e1859f"
    sha256 cellar: :any, catalina:      "d6cb1bc7221d11a5eec66b2b7a6c137f1397b4c3e75a9c6b2a9f50ecd0716ac7"
    sha256 cellar: :any, mojave:        "1911a0cea07c973459cbfad303f671e6f70ac74b981247aed537f8fc46003c23"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.11/bctoolbox-5.0.11.tar.bz2"
    sha256 "fae35ee00f8432ce04d50ddad244924af3e2dfb19e2a42c00d925c157764f3b9"
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
