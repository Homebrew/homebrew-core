class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.34/ortp-4.4.34.tar.bz2"
  sha256 "dd036a926f2ce38810c4f0aea937b3284e9bbef100a169130aed8e7ea426ca56"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "3af2134b3ed3f2f49e6d95babe8070a9c51a586870b7a9c9fd0f7c6903cad7d7"
    sha256 big_sur:       "b439662f4d3843007839accc2c1c41056a3bcf208cc76e4dbedfafd4dfa5f521"
    sha256 catalina:      "a5ec20cfebe42e7c291eb23ad4a9bb1cf5bd0f4bbc024e701b9ae1df0e58aa31"
    sha256 mojave:        "29f26f12ebbdc6cbe2a3e846f3532f8f65797404f1a8453dcad7eda9e0acfd5e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.34/bctoolbox-4.4.34.tar.bz2"
    sha256 "65530132dada3052eaf1486cc235b2986ba196b8ef19dfd0ac8ee0af761f3a36"
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
