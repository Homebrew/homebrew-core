class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.32/ortp-5.2.32.tar.bz2"
  sha256 "68f9fa234b56e457fa3ae7f64ff35ce614699674cf2de764a3407436d4efa33c"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11c66729c6b1e847d49a81e18d25017217854cf41a061df88d60bc2384425b41"
    sha256 cellar: :any,                 arm64_monterey: "4a7705996f05eb3f5f7ad86c75ac949a4bd1f67102364752aab72ce941e7a4ca"
    sha256 cellar: :any,                 arm64_big_sur:  "79478c368c023ebb5e238042016357508e2f02af8a9e4a66304450113a2993d8"
    sha256 cellar: :any,                 ventura:        "a8a569e91229ccb4b7364037b9deadcf2ba77d262568b36e538d23ade52b0a2a"
    sha256 cellar: :any,                 monterey:       "fda4ec6a2ace11e2b861c0a0931553797f5a1837b2ef9fa66ccc62ea9984c19a"
    sha256 cellar: :any,                 big_sur:        "e6adf8759299e972d6eb774231a86008b19bfe34606bdb94ae92b2b3736f707d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a1c7d4278d628e1ef8ea708d505ac7a5021f98dfa9c9db661afeedf514c9ff"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.32/bctoolbox-5.2.32.tar.bz2"
    sha256 "d3bb112521b8ba1d1281e4591783df8e8cea62218159dbc2e5b9bcbabf5dbda1"
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
