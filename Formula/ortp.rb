class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.28/ortp-5.2.28.tar.bz2"
  sha256 "0924ea45e43f01ff8ff643215c436fe083407561ee8a96145678927aa42cb8fc"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f258e1374801e2223030eeba8406ba48ee371689ac673a3939c2716913c184d"
    sha256 cellar: :any,                 arm64_monterey: "e6cc02d357eb7b1d309c3c403450d5eaf6c000d2eb2773ad440f37cc0312e323"
    sha256 cellar: :any,                 arm64_big_sur:  "841f870ee3e8cb86aae66b2cf12a5f0526be6e3e51ac2fae1d7f2142b9e3946d"
    sha256 cellar: :any,                 ventura:        "64462b6170536ae80b46fa044f04b6081a539bd327a4bddedeb558a23f2dba90"
    sha256 cellar: :any,                 monterey:       "940bf9cc2a9e6d5cd71220b67e062471bbc333c7c3c89ab34c88a82ffb08cf62"
    sha256 cellar: :any,                 big_sur:        "db52de9db992300d9aee79b8a135bc7821770dd2b3fe6f95341a066c13cb1841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "015d0686d7f03db79a6917b8ed34e454486286e59e9c079cb3379f79db0b0f27"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.28/bctoolbox-5.2.28.tar.bz2"
    sha256 "356b1478b4249c74fcadbb3ccd10396d8b28df460cef06ac0a37bd83d1885c5c"
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
