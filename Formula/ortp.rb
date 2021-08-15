class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.5/ortp-5.0.5.tar.bz2"
  sha256 "7c0cc54996833a1286caf4b3cd7b37758cd9a04db0ba4f34c333fa5c17678206"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bd78fecdcafbcde38d8e0c4fafe7bc63c95528e1d5b5f549282a174544f54c60"
    sha256 cellar: :any, big_sur:       "ba82c1b311372c4a4edc319acfd9c8b49ea8e668076bd67e5cfc5f18184bf492"
    sha256 cellar: :any, catalina:      "3b3ef5c8abe87a81483839c059c4190667745d42d75ac81344689422dfd5b380"
    sha256 cellar: :any, mojave:        "2cd99b724e859ac59291c16e9f3f8cb9b6572b1273d402296635c4eae024a7fc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.5/bctoolbox-5.0.5.tar.bz2"
    sha256 "e5fed317b6a248b7259f50e7a31a3f8a77da999c05f067640f86eada921c1213"
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
