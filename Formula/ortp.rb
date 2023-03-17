class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.37/ortp-5.2.37.tar.bz2"
  sha256 "cfa71f5f8871a4a7bd11f02695ef9141f17b1ae2861ef680825b5f9d665d12aa"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9607f3a56208f7994c36c9a3ef3b48f4806929715d4aa159b77155fecea90526"
    sha256 cellar: :any,                 arm64_monterey: "0450be2fb2de694cf10ab8b2ce9f4fce27b7c3c7b4cc8a90406c637cde8f86d8"
    sha256 cellar: :any,                 arm64_big_sur:  "b6712ad461a83a49870b0984a63c409dcbbe1959355e7ba0d322f70237380dbe"
    sha256 cellar: :any,                 ventura:        "4fcaa31f931f22023b35909c0c60f42ba7de943803662d234aee6d5039fc4642"
    sha256 cellar: :any,                 monterey:       "07771a4a6b09b86a85b0b370ddf1d82f9d3cefd4a14530c5bb5b87e18e98070e"
    sha256 cellar: :any,                 big_sur:        "7703b118d3cdd688597f87b6b8ed318dfef057710613fb68f2fb45e9b4258a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ad7589b81aaa711cab003111fbc26fd035b9a6e0669d4990faf94ec774dce5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.37/bctoolbox-5.2.37.tar.bz2"
    sha256 "8260a0698a15fefc06c4429d232c07efd0cfd7a31933c32e6135901f71a96505"
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
