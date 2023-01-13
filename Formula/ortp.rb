class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.12/ortp-5.2.12.tar.bz2"
  sha256 "7b366b201cd3ae2a7545c8cda156269d255439aa86777cc8ab4ef67e6cf343ea"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd7dbbdd99f0775fb60d6ce82e109ab374beca76993932cc19a3fb2ccb2fc24a"
    sha256 cellar: :any,                 arm64_monterey: "96f229a8dabb2bb7018c89c4d847f803ebcd86164d30681f3169e0dbb83431c7"
    sha256 cellar: :any,                 arm64_big_sur:  "dcbb2b7dba3f141e1fd81e27ab402d1d0192ce85159aa8758d5ad037d6e048ee"
    sha256 cellar: :any,                 ventura:        "9fc2532ea36dabd9e791ff59f9f013aa9c728b3eeb55242fb59c6adfd3986799"
    sha256 cellar: :any,                 monterey:       "277c1852c80bbcc076ebf84dc42d153c68f0a7e5eda964e420110549f2a919ef"
    sha256 cellar: :any,                 big_sur:        "8900f474bb30eda267c8f846422f3267345190a5e0a466cb323214fcca96d5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68e63730724276e303d341cc9241f1ba66d96cb31f0e68fc8ccf0dd9f46c036"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.12/bctoolbox-5.2.12.tar.bz2"
    sha256 "e8cac360d54d84bf4c010b9ac24f39970e4d3c7fbd2ad6410b664c5840d8d552"
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
