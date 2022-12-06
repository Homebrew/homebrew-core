class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.0/ortp-5.2.0.tar.bz2"
  sha256 "5f511597511c450ee9bc32b95bb6038082e66899961f6a035151a44d49f7eccf"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "32f172a14fd2c2ef2eec4e01f471c55178fe295e6d0aeeda388551f872cc743d"
    sha256 cellar: :any,                 arm64_monterey: "5937b311199288b8c91923b21b6622e620c4532b38eeca3bb9db515cf965ae70"
    sha256 cellar: :any,                 arm64_big_sur:  "a95039628512aa260a488041e746af520df48cf2a6800ae0e0f629cdf2041807"
    sha256 cellar: :any,                 ventura:        "53aa923af6830d2cd61795dd62beabeb2c44f4d00d3ce446800ab2c9c82460c2"
    sha256 cellar: :any,                 monterey:       "2db92343ba69ef9e9481d2cea0c947e0e538c9e03841f4cff204b47f4c040427"
    sha256 cellar: :any,                 big_sur:        "81842c97982c1b42b1bba1d4ed705c1cf6a2ad45cff3bb2e2a046bcc5dc7e646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bd779c454fb2b9ab8f8010d93b3284eac822cf9a7307181c217506815343a43"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.0/bctoolbox-5.2.0.tar.bz2"
    sha256 "7f7ca169ea7183b91836e50efe66719295a4dc8bb8ecfa7c209717fa6776b0b4"
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
