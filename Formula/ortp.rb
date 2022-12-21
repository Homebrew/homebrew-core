class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.2/ortp-5.2.2.tar.bz2"
  sha256 "3e43a10cdadcd82f10cc1953f368acf381cb6783b68371203499d8af8e65cc33"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7cc89d496e016a658871879f0fc73979672035594b9d69b241055ee5cb2e1473"
    sha256 cellar: :any,                 arm64_monterey: "a0695cf68780ed1e9379e11dad9959c959e62f17c9cd343c2364006c40d4e913"
    sha256 cellar: :any,                 arm64_big_sur:  "d36b29f77d98d9b6db3c8a8b78bf43672b3522c9c9e3474162e836ed5ea07893"
    sha256 cellar: :any,                 ventura:        "ecab60de39134d6cbe13c1badb999e650a1afc817b403a576c7128de0b401ba4"
    sha256 cellar: :any,                 monterey:       "f320283f68a915518b43a44aee636c29619a11a1d8f258a91da634f9ff89ac94"
    sha256 cellar: :any,                 big_sur:        "2b3b7fca241833505544e004e80ba883751284a4d24cdbf501c498184d854420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96356ae6535f3fde7ab5ff8c83a0e816e363b9589d767886f5fefeebfaed2fe"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.2/bctoolbox-5.2.2.tar.bz2"
    sha256 "420269457b365f91a4834935798de54e8bd00500dffa8f03ee3545835de74cf0"
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
