class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.51/ortp-5.2.51.tar.bz2"
  sha256 "f351c99152433dee776d206a677b5c6e30dcfed4babc46ddee80c6fc143d85a2"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3791b512adcf2e3754a3038105725239190485c4eb37e163de920c696cd79436"
    sha256 cellar: :any,                 arm64_monterey: "f3104e53bc2c9812a7bd5ebee3bc5a0c817927ae2839902ab3fbe9403272a94c"
    sha256 cellar: :any,                 arm64_big_sur:  "8b38e1d6dc4535c362dec9f65649dd071ad7ef2f9ce936e6713015c3a43e7f8e"
    sha256 cellar: :any,                 ventura:        "b842f803a6f0f3d2b7462e4d9f9b344e0502079d4a542ac6ed952c2c33b58875"
    sha256 cellar: :any,                 monterey:       "7671830666299daa6a4ebbf8b319f820e42b864658aa40b44af69cfc4f22399b"
    sha256 cellar: :any,                 big_sur:        "b3160c9bbd2d8057fca3bbe436577c6ce03f00163ddcbd5e3611c879fdbd32d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2aba75574fe55c6b97df7789315b40fe12952782f520f2db59bf645a8d29670"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.51/bctoolbox-5.2.51.tar.bz2"
    sha256 "75c19662f85fe92df3c16f19fed25eb733a177aecb9e40a068fe7b8f086ceef9"
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
