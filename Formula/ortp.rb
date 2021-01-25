class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.24/ortp-4.4.24.tar.bz2"
  sha256 "b7f1549c61df2b06307e9911dd2ef84a8dc4d7435fa2e14aa3910feb587dcbaa"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 "78669b4ca70156710cd55a8a1fa03ccecf5cbed3cb45fbae920bf13b500b82a8" => :big_sur
    sha256 "62f1c8ad1e1999d4fe39ddeea57d21ad04d13f87ab69ed3501f2a0d0ecb3fb22" => :arm64_big_sur
    sha256 "60d86d59fd35bcb8c892d2e6d7a944beaf25d8321bcc2aa6cd33a136249af18c" => :catalina
    sha256 "5321dfedf8c20e1bdae9086ea539eb93ba7d7211fc45105f7716cd63204d5cc7" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.24/bctoolbox-4.4.24.tar.bz2"
    sha256 "6c86fb7c4a4810c4216bba3bcda32fa9ce25be4152484c403bbd5b734a12410b"
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
