class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.37/ortp-5.2.37.tar.bz2"
  sha256 "cfa71f5f8871a4a7bd11f02695ef9141f17b1ae2861ef680825b5f9d665d12aa"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70dce9b8ccc12f5849e5434c50efa06debf0718ba407b1c2d499b9066b12752a"
    sha256 cellar: :any,                 arm64_monterey: "7c713a25711942c950a90097f340258594d7c3d25a3c4b47bc56e78753784f7d"
    sha256 cellar: :any,                 arm64_big_sur:  "75ee512a931e7f2a627e9e7e23b0a716e3a2528d6d55b50bc6197cf3d97a7ac3"
    sha256 cellar: :any,                 ventura:        "5da8fa8cde849a83f144e8b2cb313a42a601af4532c948ad7e51e11a083e41e5"
    sha256 cellar: :any,                 monterey:       "ca16a455d60c7e5e4c34dc028eb711d5e4135685a14f20f96adaf24447a5d40d"
    sha256 cellar: :any,                 big_sur:        "59530aa160a2857adc6f688315ffa53e3a6b0949d1fe8243bba37bfae3bcb79c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f7ef55961a294d411a53f4ace635e62d25ae03469ce0108590c54b35bb26de2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.37/bctoolbox-5.2.37.tar.bz2"
    sha256 "8260a0698a15fefc06c4429d232c07efd0cfd7a31933c32e6135901f71a96505"
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
