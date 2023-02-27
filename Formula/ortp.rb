class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.27/ortp-5.2.27.tar.bz2"
  sha256 "c3eb171db40972c952100dc67ca01aac5486c590873bfa09b2579d8959687c97"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ad1b60d0e292c1fc993b2a1c7fbadd85e3b6eeeb8450ef5a92e72c0f790ff5c"
    sha256 cellar: :any,                 arm64_monterey: "f4e3fa82caf247e8921e60b23d55f060d6a00a432759205124cea053eaa1f890"
    sha256 cellar: :any,                 arm64_big_sur:  "9f2207f3f18ed35aa2f43bf62dc33c535028ff502009669bafd99515096fac98"
    sha256 cellar: :any,                 ventura:        "267aa0704ed2750da7b15430dcfc06fe6127d5bc60eb3b4d0413140bceff29e1"
    sha256 cellar: :any,                 monterey:       "0b86ce40de1e0177946a7a0c94375a5c0ac9d1729cc21541791f0d9bcc5ef8b0"
    sha256 cellar: :any,                 big_sur:        "a416b2ae182f7b536fb5325248b97a105460381274ca611c6fb34097a8b69c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af4f80821b084b07f4fc6e286ee84394027ef9d1a1218c68c26d1d466b7d43b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.25/bctoolbox-5.2.25.tar.bz2"
    sha256 "e4be6d23f842ac9e47e8a7649d20362b8b3e28565466d0488c7200cc02ded408"
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
