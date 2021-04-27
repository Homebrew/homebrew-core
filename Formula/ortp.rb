class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.5.10/ortp-4.5.10.tar.bz2"
  sha256 "642b1b75e4d9483402783eb4adba4bec78b519c8a72673e0f964d8af0275e3e1"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "c2fafc5b253a3178882481c11fd5ac6db3e7c9c599434dbc5c00d6dcf38a53bf"
    sha256 big_sur:       "c5a54a7bdba5729d1209996f849d930048e6b8f3cba5263482d624cba3fe5584"
    sha256 catalina:      "bcf51502cc19908995d6bf9beec0f03cbd4181528034a717c3b05ed2ecd6364b"
    sha256 mojave:        "4821b67bd7fbd0726cc27e7f389fb023cf564ff9ef008122d1551e70710ac4c6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.5.10/bctoolbox-4.5.10.tar.bz2"
    sha256 "a2daf588a3aca4b5de2af2c118a57a9697bee819f43387290eaeaa09c6e7f497"
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
