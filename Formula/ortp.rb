class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.58/ortp-5.0.58.tar.bz2"
  sha256 "b8e2d31d59d6d7a3a27b40b7f41c5df145ae2b3e4a632b81c63af0261a607af6"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e1f7aef063e65db2934779fe7183c6592fe28dc10798bd90428d5645bf1b897a"
    sha256 cellar: :any, arm64_big_sur:  "f15dd9a8ddcdef7d9bd185c9f46216b78bdfa01d5a6093bffe973197567ea39a"
    sha256 cellar: :any, monterey:       "daf9357690dc79d3fa60a98696b30254eeef47d8d657128f1794ed515608d22f"
    sha256 cellar: :any, big_sur:        "0b7759ea88e3c696804f43fa8551f0ed1f5b9ba4c9e5509b480d24eff89d235b"
    sha256 cellar: :any, catalina:       "0ae4b71e47bde3c050941023dab017cef038c373dab30ecf20b1f43220232e21"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.58/bctoolbox-5.0.58.tar.bz2"
    sha256 "d5ed3f9057be40d1949da4e91e2c2bc173f23bde29f40a9e9479947a4ba46561"
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
