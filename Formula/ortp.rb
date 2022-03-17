class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.12/ortp-5.1.12.tar.bz2"
  sha256 "7ed33dc6085c0323ab8547cf20e6e501433ae685558eada33942d0dafe8f027e"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1f483636a01aaaee33830d1492c71ca76cea7a8b122c71980a58a061d223236d"
    sha256 cellar: :any,                 arm64_big_sur:  "246617d615c1fcef29ce0a64bb5b43ec47b8301d0a2825823ccea028293d3eab"
    sha256 cellar: :any,                 monterey:       "b17941275af16c33a6aa0a600da620da69d22ea48d7a281c2de171241af42d28"
    sha256 cellar: :any,                 big_sur:        "d53243543f5bf4b516489aa32759214699aeeee6446fa68db4fdda4877f0f89a"
    sha256 cellar: :any,                 catalina:       "2c22ce63346c94816c1fd3d5ae170d1d65f645fe53ef6254504c94c0493518de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6bab26a5666d30b706e5a3eddef3df7b945689f061dd0d0c2e449bc8ab3e0a8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.12/bctoolbox-5.1.12.tar.bz2"
    sha256 "a1f777627f0f0304ec56155f65d3318424a55b909d8b13d3012709a659b7c604"
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
