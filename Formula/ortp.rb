class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.31/ortp-4.4.31.tar.bz2"
  sha256 "04b236b76f4ed3090b4f86f41a4a7a481531c6590e9d01e0849ee4caa1381bc9"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "b54b4aae25475bc122d33ea94e35d6efb1b79afcaae9ff7f3833acd0a4ba9933"
    sha256 big_sur:       "c6c55aa142bd3d13ccb1af4cb09a15986e92a5d6cda0ba020811790a993bab9b"
    sha256 catalina:      "12b274687b001a628f99e8c54455623202c323308a33cf193ca0b80c62e17ad9"
    sha256 mojave:        "54b68ef552576ae128da38ffa19ae0c5370c5fd64d1f3a77f5129ebdf6df879a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.31/bctoolbox-4.4.31.tar.bz2"
    sha256 "7b29e0fe077b776eafd01ed4434d12a62a9e06bc656594ece9950c235d950c0e"
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
