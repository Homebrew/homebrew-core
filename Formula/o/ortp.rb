class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.112/ortp-5.2.112.tar.bz2"
  sha256 "710a28c361a863132a2b8dc1577213132524d71df0acab7768d974ba0e9ab2e3"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c31e9e6113609e83a1c829a3f4b95228590c80daf255277d9e39af6fdccf1716"
    sha256 cellar: :any,                 arm64_ventura:  "3656b5bd57ed56e62385eb1d5456b895bbeb54b11dfd0e69afd71b3605f0b2e3"
    sha256 cellar: :any,                 arm64_monterey: "bcd11719f32c269895adfb8e03382ced461e0efd90d8bc876e627df542d2519a"
    sha256 cellar: :any,                 sonoma:         "67ecd398846fc7f129a818b8033149987bc84997b9d978638f2063f47f1ef92c"
    sha256 cellar: :any,                 ventura:        "407d6570a881f18bc76e3b7cfeceee0a5961bfbc540eb57e14cb0e0c29a82546"
    sha256 cellar: :any,                 monterey:       "f901b863ac56a71cc10dfe5f805acc60f42c61f3c7845993b464e682a8ce169b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f033e152be2ba6242334ea22daf7667ec5b93e2120bdee814702dd073dae9a13"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.111/bctoolbox-5.2.111.tar.bz2"
    sha256 "fe0af1dcebcc5bc6b45d2822d51e8b9093467a5b1d3c4b5f3ffca26b77aeaead"
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
