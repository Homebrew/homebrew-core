class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.66/ortp-5.0.66.tar.bz2"
  sha256 "f71c8a526281a6450a7d56fd8671aebde4e94d16df9d8ab9a45087d18e4b0650"
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
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.66/bctoolbox-5.0.66.tar.bz2"
    sha256 "6e8c0ff800fffebc07ef465a33a1c0f1809664e546791e2dca2f6e4f23c27196"
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
