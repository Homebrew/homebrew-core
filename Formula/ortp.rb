class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.71/ortp-5.1.71.tar.bz2"
  sha256 "40f3973162828cea964317bfcbeaa1386b564592b622f1b20dc7b99434bbfd74"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d9103c16168a4a01b23bd0cec321dc710c530c21e98727b2a8e7e783e43d3156"
    sha256 cellar: :any,                 arm64_monterey: "e84a377eed46dd52659c0589e1e047267cf5e7275c43f556bd20dcc490a09baa"
    sha256 cellar: :any,                 arm64_big_sur:  "04aeeb151143004112806488b133107ef9d5f3dc5a8f70d96ac95108b8f14945"
    sha256 cellar: :any,                 ventura:        "cc757a7b8310a0412257823e8a7e574afb28221a844d89d9b34dda9b32cbece9"
    sha256 cellar: :any,                 monterey:       "37349fbacc100f866d8ace9dc799c234fa2a05297968cf99b75ec7f108d7ec88"
    sha256 cellar: :any,                 big_sur:        "5b9e877571b365593edbecf2627ba7723aa99d54dad124c5a821361138897eb0"
    sha256 cellar: :any,                 catalina:       "0018ba0cda83ead7db31059c6c517819edca280d8aed6c6c4543e118e9a45b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adef54b4ce2658abbfb549b87da3feeaa3e87ec666418ee8c0cd7722465efc0e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.71/bctoolbox-5.1.71.tar.bz2"
    sha256 "eedb21617b594b5997222f35e119875b9d30bba1b43f302ec6ecdd0d6a614497"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DENABLE_TESTS_COMPONENT=OFF",
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
