class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.5.15/ortp-4.5.15.tar.bz2"
  sha256 "f19763c0956cb43c94c0c189c4bfc6bc6b7dcfc7365e10056ade83423b637d1b"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "22b25d28344d367c2ee59dd9fb83ca4ae26e7b57b6c3ef8546e2fa301546784c"
    sha256 cellar: :any, big_sur:       "eab92afcc704155f47615ff7652ed2b15e716b0aab7c4fedd02e310d7587ff8d"
    sha256 cellar: :any, catalina:      "030fce566d899c030a42952dc7d264efb5ba593a1384ccd90189bc818be6b6ec"
    sha256 cellar: :any, mojave:        "6c7bca1e539a27e1be4a102433a103d354b10de57bbad65477dc4411bccb3e40"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.5.15/bctoolbox-4.5.15.tar.bz2"
    sha256 "8d74ca90e111f733e666801cbffc59e7fd4dfd632b1d338841091769ecbc5768"
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
