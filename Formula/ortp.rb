class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.10/ortp-5.1.10.tar.bz2"
  sha256 "1e7a899285115ed54f72a5792400150b57e92456bf5f0d7f446d44a1becae1d0"
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
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.10/bctoolbox-5.1.10.tar.bz2"
    sha256 "d781778244df6506c6d17cb65f6da586ef26bc2222531747d371e12097948e6f"
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
