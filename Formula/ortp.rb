class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.23/ortp-5.0.23.tar.bz2"
  sha256 "788f928c0e7b54245c78ab745890651a752d648761b67763bf0fdd1f7425defd"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3d204745ea3534e21f5171d040bd58e565b398afc7e42c01e8da27301297fcd8"
    sha256 cellar: :any, big_sur:       "79c20b778de10705e8b1e7af10763215d45c4aef83c5bd1c27e848af887a396c"
    sha256 cellar: :any, catalina:      "10cadafe20724532016c7efcc7cce6df6ad4703b18dd05929bdabf32ec57aa25"
    sha256 cellar: :any, mojave:        "912186418879b39eb6cb45441c05d6f56de9e7a409f486e87c04a25a832db0a9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.23/bctoolbox-5.0.23.tar.bz2"
    sha256 "d3ec3c5877cded70f2a9aa08ee42e1e0ebf1ed858b4d12c46569494b34d1dd04"
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
