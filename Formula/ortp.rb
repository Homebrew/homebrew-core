class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.29/ortp-5.2.29.tar.bz2"
  sha256 "53a65d07a7c5c62721624d96cf265ca40bece5c4da67c78bd1e3f6aa7af70f71"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24321e3950c77647677200b88d9a1ff177167e0b1fdeaf163064cfcefbbb1bec"
    sha256 cellar: :any,                 arm64_monterey: "4d154a6e3194393149e7de43d4cb01d56d0e3c13bf40d01f9fa49223b28b88f6"
    sha256 cellar: :any,                 arm64_big_sur:  "582d0f320c6f5ac483b60b7a8e81b9fb1320a0b96fb75800090eb3c15c4833e8"
    sha256 cellar: :any,                 ventura:        "1c46911afd7f323bbcf8a8cd5cc256122c4b259f3a1dad36f41beb562099c59f"
    sha256 cellar: :any,                 monterey:       "5489e000d74b4e496dd1f8c91b46ad938f455719756857eaf28bb7068ebf7ccb"
    sha256 cellar: :any,                 big_sur:        "519e2336b0861eec4499bcc07d2b6e8717472b3ac02851edf18d024b796dc013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ffe07f64e21d08f0bc411279ff23e1adaf46414c881771d3157fc90d2d8107"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.29/bctoolbox-5.2.29.tar.bz2"
    sha256 "bed1ff1c2cbae57f9a7a75d9ca2a25b58f5bcb7f758d4e396fd73b5c0f6934f9"
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
