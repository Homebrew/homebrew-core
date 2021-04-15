class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.5.3/ortp-4.5.3.tar.bz2"
  sha256 "7d5595d2134b90f0db749e48c6873646f44c125b17af02dc60f3ead4c4f7c0c8"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "fa30f96aa702b65244a8bc335b80b654277994e06405bb2cc366a12957f5e3f2"
    sha256 big_sur:       "1f941c9d60380a1119dfb3dc2518b21fbdabf52fd2ec5ea3be56df3004937977"
    sha256 catalina:      "ae4935f6d1b4d51a3b3ac5d695f72a3138aac90ce3ca5465a68c8eb48ff3718c"
    sha256 mojave:        "77b7f16459b93603e6c15a8d22a9388e2f214b501b26f7368aab2866cefe27cd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.5.3/bctoolbox-4.5.3.tar.bz2"
    sha256 "a59417583bd44920eba436a90bb9d6513f6ffa0bad08059280cb9d91087b2461"
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
