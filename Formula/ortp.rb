class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.71/ortp-5.2.71.tar.bz2"
  sha256 "7414e3c933aa7d78881dd81f131e41595d9b60cc6f96544c8961058518a9709a"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c5322d82e8e55a29d79376a071a8a0c6f49858efa0197870b76a96d96b2b07d"
    sha256 cellar: :any,                 arm64_monterey: "aa7f14365c378e5b1aa9d0cbf156341982f858e95b7a0ef1621e3a000c885656"
    sha256 cellar: :any,                 arm64_big_sur:  "c1cf26bac4bab4a064949d470d7b3bbae8555bc44fe1f39a095bc37a48665ec5"
    sha256 cellar: :any,                 ventura:        "12f87a6db53bb707a7d40adb5767bd6f4da7ca22b4631bf84b0f8593fd54124d"
    sha256 cellar: :any,                 monterey:       "482177f7261389c6eea73536f4697c64b11a23bc2ab2909b8be4448561d9cf54"
    sha256 cellar: :any,                 big_sur:        "947797a5c0a2be70514d829736ef0a8efb023ec33446492fe2085cc546a9cbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63a59171192edabb4231b6f8fbf14f04894405ac72a448617db72d3aa625b87a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.71/bctoolbox-5.2.71.tar.bz2"
    sha256 "48eace9a9c82002f0983b7030abccdd11b45370b06c0d1251a111c7fb7b869a1"
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
