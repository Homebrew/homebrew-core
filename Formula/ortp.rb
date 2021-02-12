class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.28/ortp-4.4.28.tar.bz2"
  sha256 "9a9b5a2ce9905c4f7a154c0ee59a3b3aa1f85d783113a60dab1a45da3229da58"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "9ce58565f3e54016124c4e9ddd0d9ba6f931ffac6ce5b95a7066d38112e43c17"
    sha256 big_sur:       "52fb8ae3d2db6fc993c30134ff96c04f4e560b16e82f89eaf206830f76b90de0"
    sha256 catalina:      "d33fbcc9b3e1e2c4f45eda4e2bd1c2e85fae8c48b60d2239b60cf6c1db546aa4"
    sha256 mojave:        "105cb5fec0c5b0cbf4d208a405993a27196e5530af09c903b259a729265091ae"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.28/bctoolbox-4.4.28.tar.bz2"
    sha256 "f7daef6efcee2a3fdcf2378d3d3465cd1ee69bf74c755a9b70ddca8cf46c3bf9"
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
