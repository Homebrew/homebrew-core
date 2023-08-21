class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.95/ortp-5.2.95.tar.bz2"
  sha256 "edcffd263fcf5c58f78d32769646ae6e0b3adfb7181849dc7590dcdcf16a93d0"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a12f10b28bde459791cf5ac4f8c59852d366b8b81a0ddb2b9296ba0a0761b4d"
    sha256 cellar: :any,                 arm64_monterey: "374090a1c05ce6f7bbde06981e671693cbd8ed14fd8a02f2764f292a4fc567d6"
    sha256 cellar: :any,                 arm64_big_sur:  "1e78ca065c59c54743e4b1a772f6df7d44530350667dca098261c2259d59e402"
    sha256 cellar: :any,                 ventura:        "94cbccd5daedcabfaf007098b62dcc5c492250e7f448dbadb6b412a5f77085b4"
    sha256 cellar: :any,                 monterey:       "37923e4e5583e98e6ae76becd1f631739756b91836af694ab37b16bf0ca95b2c"
    sha256 cellar: :any,                 big_sur:        "3abecf99f45af5ceb14263811f5d64b71f35f597ccf0b013030a230bdf8edbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c35c68037006f2866feb06108fcc465f823ff52803756d83b8ab397c9b52e8c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.95/bctoolbox-5.2.95.tar.bz2"
    sha256 "2cb2eb438c83f0e846557feae635194084abd7652eb693e613679fce8fa406ff"
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
