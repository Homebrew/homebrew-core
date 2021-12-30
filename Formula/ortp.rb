class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.61/ortp-5.0.61.tar.bz2"
  sha256 "283ada22cd397b2b7a1dacedf1c02f40e3961f849dc917736f92e092f4373dd8"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f9ae11548849233fcb4d2c8f2ae66ae31640117b2645fc48b47482e728a06a4a"
    sha256 cellar: :any, arm64_big_sur:  "e494dba350db6dbdd923b2fa01b905b4e86d17826bd97317340acce90836c53f"
    sha256 cellar: :any, monterey:       "2dd216eaae0b399b8dd197cec9c59396d23afb4c9d68a3dcbef0ec47f17846a6"
    sha256 cellar: :any, big_sur:        "16cd300a0845c3161ad763df483692da2a9f730623dab58ff78a35c793aa4a76"
    sha256 cellar: :any, catalina:       "4df7ebd642c037fdd53d6f6b42f3d72fb9f491b88a87a3ec5e78f77e5ad1aa54"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.61/bctoolbox-5.0.61.tar.bz2"
    sha256 "84e18d00887770852a55c64493ac98fc8d9a3aa51e8aac4ab32a55cd5b618b0a"
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
