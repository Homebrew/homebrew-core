class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.73/ortp-5.2.73.tar.bz2"
  sha256 "32c9b4a42ff4e34f5a546820997c114ee82e04a0cdd9cc0cabaf0c96425eacac"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "78c40665ba0122ab5575ce6a896f24924c4303f4379b2cb86e2c4c0e48221ded"
    sha256 cellar: :any,                 arm64_monterey: "446232068322edf29eb81598d3e8769766ff2a26b29717c05e1aefba35afaa72"
    sha256 cellar: :any,                 arm64_big_sur:  "eeed857f5b8ee96f71eff43b836a0986254e00e419adb41eebed05eeb77980f9"
    sha256 cellar: :any,                 ventura:        "ceae90bc61e545f03eac8fcff99ba3f462bc1a9ab3c31a5a5cde4c9cf2952776"
    sha256 cellar: :any,                 monterey:       "389f82e5e49f7a73294f55373a296e9ddf10ae71c70a1c31e5841085a287046c"
    sha256 cellar: :any,                 big_sur:        "0c474bd162aeef90c01c27ec54fb0efbdd0400cf407140a97cc464630cec1653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "903dd3a8f4569108baa41067707cd3c9a4c5d59cc4c395bbde7780ef46233ed6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.73/bctoolbox-5.2.73.tar.bz2"
    sha256 "575b56339805837799c173508f657008f123f6474077b10bdfe6660659402ca4"
  end

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
