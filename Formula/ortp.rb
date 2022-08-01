class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.51/ortp-5.1.51.tar.bz2"
  sha256 "a5fa6923db766be43298118136fd6fa0c7d7b1050cc296bfdbc774d3022a13e9"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f0754d41c6d76b4c7af74b096b6bad92fd1044711695ab145afcccee4bf3e8f3"
    sha256 cellar: :any,                 arm64_big_sur:  "1f1e8fd25db160f24d1e7374bf1f97d3c11b945f209599f567ff38fd61b139f7"
    sha256 cellar: :any,                 monterey:       "a94522c619dc71e8332811eeeacea21e9d73d774b11fc0a8d6a960a66f160042"
    sha256 cellar: :any,                 big_sur:        "10f4beb11c5b73c2bc97a12e88e7d72c9ab5797abf837e5cef94d1221006b702"
    sha256 cellar: :any,                 catalina:       "9216e99360d8f8959854faf916b74e5ab7caf36b75047cd66456e71848e31d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4fe9107ca25a8fc62aee78ac648a6447ecb78e49a5833b03bb2948cf888ed1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.51/bctoolbox-5.1.51.tar.bz2"
    sha256 "bc1a190de273483cec81d1be761f5254451fc875f82a26a2b53a0ec0fde3625c"
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
