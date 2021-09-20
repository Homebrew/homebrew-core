class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.23/ortp-5.0.23.tar.bz2"
  sha256 "788f928c0e7b54245c78ab745890651a752d648761b67763bf0fdd1f7425defd"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a41f8a27984e61f7b90ce501b6ef4d7cf90a02816668396f58dbe11a4efe3aac"
    sha256 cellar: :any, big_sur:       "710e7827d6808dc2cadd9a867c84b42cbb2dc856fb2ee0c1e79056164f4624a8"
    sha256 cellar: :any, catalina:      "28b8267133f9d77be72851361454cb09e90a67bfa472aedaf0ace33f4862cdbd"
    sha256 cellar: :any, mojave:        "98cbf54721d04bb914fe0235dc0eede809fe89b6fc085d36e3af9098607d8616"
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
