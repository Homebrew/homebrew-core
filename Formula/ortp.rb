class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.31/ortp-5.1.31.tar.bz2"
  sha256 "220f09fa805d20a1f2ffa2664ebddd44f622bcdef54db60fd37f30ef8e3ff84a"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a9d286da3ebb432d9a776b68193f0aa23d4edf83810818c1821f9cb168de7034"
    sha256 cellar: :any,                 arm64_big_sur:  "f9f0e10929d4920fe83b298d8dada7b9ac8a87309c57fa9efe2c4929ad9006fd"
    sha256 cellar: :any,                 monterey:       "fae9653e5023215977c9a69885591e3c4bedde85b304feb25cf7547d16bd8c01"
    sha256 cellar: :any,                 big_sur:        "49ab508303ac455600a4bec7ce522a06d698f57859677ea00c4d8da4ce716db9"
    sha256 cellar: :any,                 catalina:       "200ed91237e03430dda6806f12bfd4c1363279675818ba903b255950c5e07530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a7b556d658a05801f220d1fb18d7bc3e64279fd03cb038bc501c5f27e36a0fa"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.31/bctoolbox-5.1.31.tar.bz2"
    sha256 "90a3253d2418ba810436aeb23aba6e00c08451aa4b5ba7f9bfa11e04820da34a"
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
