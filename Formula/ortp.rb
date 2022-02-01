class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.67/ortp-5.0.67.tar.bz2"
  sha256 "7961e1cbfad025376ab8ebbe7608e497bb6f75f2c92a3c58b60af80709d86747"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4e335e442ab8b7714fe6735567cbd4a8f89d3a6bb7fd785ee506c899d5564757"
    sha256 cellar: :any, arm64_big_sur:  "e813fa372e0e41246e95ee5eb418e16d19d130449a2743bebd994b986440a342"
    sha256 cellar: :any, monterey:       "c4a50e8aacb06b5ce76dc67c2f279b2d9ea8ba6f3c0e378194c439760767bc98"
    sha256 cellar: :any, big_sur:        "e33582285d2b36d65d4b03eb7ea85e890d3d30d95168c4a7e3b6c42c856227dd"
    sha256 cellar: :any, catalina:       "0a151712a042b19805312c37aa007178cb394f18fc3a45fe1ecc8e1b8a4e9a75"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.67/bctoolbox-5.0.67.tar.bz2"
    sha256 "7ede83ad993290c2d490a62ab5b1e4fe14ce800a9af85526e15a70adad1bd202"
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
