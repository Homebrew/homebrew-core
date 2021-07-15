class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.5.22/ortp-4.5.22.tar.bz2"
  sha256 "c30fd72e7847b32b5aaa31dc5a82c92856c59ca8cb8128d50b3c0e38104d6376"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c56822e5d44021bb25a0bc95045624d92f1d445b25dffdc35686869571f8b0c2"
    sha256 cellar: :any, big_sur:       "b48c4bb9ba4dd1dd15b7df0854b627d63cce033637aec930d345bd6b9dcf6a29"
    sha256 cellar: :any, catalina:      "1a178b29896e490484183ef3ffa7f53ae7a86eaf7a48fd1e96eb57ae6d384c85"
    sha256 cellar: :any, mojave:        "116971d671d3c6e2114f062baa43754b33759949c6b49d337d536ba87a8f61fe"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

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
