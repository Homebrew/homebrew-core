class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.54/ortp-5.2.54.tar.bz2"
  sha256 "2955add71313d66ef4443cbfe1394c79a25fb8479b04a64603830a2515f56de5"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e1fee0a3eabaa5a70076d6650802d48cc9893e725ec4d0170b1cdf7199e13a4"
    sha256 cellar: :any,                 arm64_monterey: "bc4f716a27ceb1eae6c31ba136ad4a9e4c7f37fadc5856c6fbe224f8d0d912d6"
    sha256 cellar: :any,                 arm64_big_sur:  "c62a5325cc3eaa2a5da09e95be652ec24eb2b13a3700c7fa6d17a733a4f84e45"
    sha256 cellar: :any,                 ventura:        "4f0e59a90a1b505433b71624de455f718087c4c7eacf2d86e59aaed2e49b20d1"
    sha256 cellar: :any,                 monterey:       "83d5a03fbed24b96d277024e2a38fc5db8a393aea59b223637ccc90563f310dc"
    sha256 cellar: :any,                 big_sur:        "34c97998af6db0bf4776762d3f8367d929fb138e57c8ad16a0a3ae6e3537aa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65ad28351449bf3a0b07cb3f6a878c0a0182626b6575940dc32def64e4ba55a4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.54/bctoolbox-5.2.54.tar.bz2"
    sha256 "9a890fcb66b45c3dc1f1b3ef572535babcc7751850fdefa5b837c4fd7bc8e41c"
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
