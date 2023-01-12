class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.11/ortp-5.2.11.tar.bz2"
  sha256 "e7c7bd669735a47b0bb2270478b91c6d577bda83995b3ea6ce59ac6924aebd04"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8082f07e815ef8a36c015286016ef07668e71a37f492afaed5797c0a74713137"
    sha256 cellar: :any,                 arm64_monterey: "7cc022ea87718f373eb9d2468b560164d3adece3cf3aa1871cd8aa3a2ece0400"
    sha256 cellar: :any,                 arm64_big_sur:  "af9cd12900bd0bfd096c2f930bc18b45fa704d96efd92ee8ec0faf064a1b1730"
    sha256 cellar: :any,                 ventura:        "a583c8c714d43963c608b89e76be55d8c9d9396c6bac344a8b93880d254c9687"
    sha256 cellar: :any,                 monterey:       "600a806a9e8f8a6f650d1dd9117beedb60cd0a65352c83fbe59f84eca9b9e98d"
    sha256 cellar: :any,                 big_sur:        "9864677f53f1f7c1db19657bae20266f75cf0be55f729a710b06b032bd5fa26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b778e7397e2e6d7cf7d08b7c14f7f13fa6831894047e3bbd60f7f0da625d5a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.11/bctoolbox-5.2.11.tar.bz2"
    sha256 "6cd5cec044b973e4311be7ee1135cd39a48f1d3cdbfe4aadb76dccd511603888"
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
