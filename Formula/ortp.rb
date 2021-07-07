class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.5.22/ortp-4.5.22.tar.bz2"
  sha256 "c30fd72e7847b32b5aaa31dc5a82c92856c59ca8cb8128d50b3c0e38104d6376"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1939dabc8c80305f35b3244de7f6c1fab71c54b43416ba07f6f398019ac68a6d"
    sha256 cellar: :any, big_sur:       "2d25bad15b9ac8d4fc55bd8989be9ba6a296808f76ecc5d5115567ccc6e78ec6"
    sha256 cellar: :any, catalina:      "e44c68f9c34d1ecfa737de1d42697f731f87dc9949fe0d70834e47f93478f31c"
    sha256 cellar: :any, mojave:        "4dcb1c86c0164a8b1ca311ccf0d2dfddb20e350a0dab9d27aa77e48bc34790a8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.5.22/bctoolbox-4.5.22.tar.bz2"
    sha256 "2c659b572e909c4beac3f1e5565d3ba1565663243228b803a9ee49ff1a9b1cf4"
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
