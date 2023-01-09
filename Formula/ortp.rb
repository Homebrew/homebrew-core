class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.9/ortp-5.2.9.tar.bz2"
  sha256 "518f4afe5c324a26b9f346f7de608104bd447a89db05ab754bf5e451be4438e5"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e462cab0e6909834bd78de443d5a1dfaafd902e6a2adde629c7f398bdb694cec"
    sha256 cellar: :any,                 arm64_monterey: "2bb4b861f23a1de75ed694c9ea780344b1a553705109139e0f80b0a6b89fa841"
    sha256 cellar: :any,                 arm64_big_sur:  "afb8ec41fd385652e5ad8f24dca46ff6bff2534606bcd20aec74abba19228409"
    sha256 cellar: :any,                 ventura:        "e6aec7bc9a698b795ad649707b0ca9c693f5ee2371138f6cb7cc9381de66ddf2"
    sha256 cellar: :any,                 monterey:       "4701f2736aa4e3b103e41c78c38cb7e608b1d94bafc155cb44d570ce0b1f7ce9"
    sha256 cellar: :any,                 big_sur:        "83f2ceb91a635168502d005ea94ca835de99aab9e116977008f820db178a0f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7035aabd220c44387f1588610ba7d9d7789b6cf9e5ad8c3331cf2bbbe910e1ba"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.9/bctoolbox-5.2.9.tar.bz2"
    sha256 "b48b94a3966a3ca64225064551b7c37244c7dc53a9d89eab05bdac60421699d2"
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
