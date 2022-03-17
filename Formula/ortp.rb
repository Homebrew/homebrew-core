class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.12/ortp-5.1.12.tar.bz2"
  sha256 "7ed33dc6085c0323ab8547cf20e6e501433ae685558eada33942d0dafe8f027e"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b32343c7016fe24f09c67194cd7fd5b1a34d44f371f044d7a427738b9ac98fa"
    sha256 cellar: :any,                 arm64_big_sur:  "af954418bf3f68899b6db7563cfd131d775e3f1bb82eb07c3fb07f56ed16dedb"
    sha256 cellar: :any,                 monterey:       "eeb7692b2499bc7d2d70c0e71fbd08458218207fc749e0b852664b6ccf7f0ee9"
    sha256 cellar: :any,                 big_sur:        "326d6799b7492c9d2bf1739a57f0387941353594133176d83676bfa2ed7e5bd5"
    sha256 cellar: :any,                 catalina:       "4892ad9ecf62b96a9535ad024bd4e081d775c0b23feddd3248d725cd89a9830c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c41a492928bc08195c98cc62331295793bd38a8d09ee31a80f54fb41fc9bc3b"
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
