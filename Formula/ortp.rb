class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.67/ortp-5.1.67.tar.bz2"
  sha256 "9d2f939647dd74658213447ff05ccc492bab60e0d37d16cfca614185208dc19c"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dde8c01429ec087a657df80bb000cefd93895d14f4c886bdb8cf72a70efa63d6"
    sha256 cellar: :any,                 arm64_big_sur:  "38e16f729f3853e09fec6998e1aa213e446bff3e6345d35677eb011a498674ab"
    sha256 cellar: :any,                 monterey:       "76983cd75188557c3e74c84ebee9d447ce24f2f8d607398c1b84348fef3dfdca"
    sha256 cellar: :any,                 big_sur:        "cfd50d79e2e9e6a95c374ec9bee6c6d54b762f65f074a4e525a2f9e6cc1d7c96"
    sha256 cellar: :any,                 catalina:       "7fb3c78d55524eb1721c322e4a61b14ce10eff9a30963648828049ce78c5bbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da6a3982a419dcc395769c5006a4026995eb73028991f8192caa820d70156804"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.67/bctoolbox-5.1.67.tar.bz2"
    sha256 "ead8045f0759fcb67559e1b1745288771f349bed03dde4af216ec45c93a09755"
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
