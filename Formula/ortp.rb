class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.33/ortp-4.4.33.tar.bz2"
  sha256 "89edfdbc92ed5c27e4c35de64de07934a9db6e2579f8dde5f8a14d7df3cf9768"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "d103bea9a62c70b36ee33e9c7ccb4c4a05c195f8ec918450274718c14786b6a7"
    sha256 big_sur:       "80b0421194e4b85bf520d3b64fb89b0ef02ed243a6958ee7a5ea53c7ca74299a"
    sha256 catalina:      "f3acc3ff53dc00f026a8c7f4f116a1e81e935d98928ebdcd97c68d031e17b67c"
    sha256 mojave:        "aa28c6742fff2d7199eb289d080ec51d37273eff4c1e65dfb87d28cf478c539a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.33/bctoolbox-4.4.33.tar.bz2"
    sha256 "4aafca6f4abb02666aee24518ce42029739507e5f149728f29a4bc9ec2ebce1b"
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
