class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.45/ortp-5.1.45.tar.bz2"
  sha256 "2f6bd8735e94e532567e53db02488c430a0184596d9dd9e0b063d2e7d841a35e"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b2eec2d1f3794de780222a7a90384e0a637afc2620247b756ac42acc0884128"
    sha256 cellar: :any,                 arm64_big_sur:  "b7169f22cbfc96804b4c586827482d93b3f6fe6e94dcb8229adb9353ab3d15e4"
    sha256 cellar: :any,                 monterey:       "56810995ce010c76dddebfa624850d63fc2a9762118033914e6fee56cd425f1a"
    sha256 cellar: :any,                 big_sur:        "9e75561312fcab0dc87b28bf3b170ad48e08d0eeccc161108448f98f5d4e5327"
    sha256 cellar: :any,                 catalina:       "0599a0757c5d76c6c5230632d3370778b9e993db49a2a1283513cc42ec036b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d856b968a12fd5a4e25a6c9b40fa17869675b73ff1fd63f6faa3da02f32a4cb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.32/bctoolbox-5.1.45.tar.bz2"
    sha256 "d8a1374c36cedc0dfc09fe6a67075b55c13006386c466413a6af29941e9e7e65"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec), "-DENABLE_TESTS_COMPONENT=OFF"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?

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

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
