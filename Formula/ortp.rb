class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.71/ortp-5.1.71.tar.bz2"
  sha256 "40f3973162828cea964317bfcbeaa1386b564592b622f1b20dc7b99434bbfd74"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c89fd323319f7351d6c4ed9bf6c850fa7562cad49a4d36b598f6fd7418aeabe"
    sha256 cellar: :any,                 arm64_monterey: "034ca6ec61ee397a1426555ba0695f1b5f45ae19c8d736113029ba62b7567bf4"
    sha256 cellar: :any,                 arm64_big_sur:  "191ea4a4e8249360131e257bedd5b98e1436200aa9ec1fc7cc0e120b0fcf1c99"
    sha256 cellar: :any,                 monterey:       "ed76941ee6aee026790fa63a11eb3bb574829d5b651afa2fe5b1d9e4e9837857"
    sha256 cellar: :any,                 big_sur:        "5c44966ebcde4641085278f79b826cc039c07bfe678250000bad3ec3723e625c"
    sha256 cellar: :any,                 catalina:       "1e9044dcd41b2e7466e2e5eebfcd05162ac0b942c6c71f1af0641e859c657560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95319c7dc03fa9eb41faaa255b37b633996e09bcd48ff92a1a5d6fcef0c13231"
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
