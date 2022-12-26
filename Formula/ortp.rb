class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.6/ortp-5.2.6.tar.bz2"
  sha256 "a601d72ccea413033a20dda3a0a1cf279ec7370cfcbbcb5dbff3c2f7e726ea34"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43306cc7eaaa7663292ff7ee06b99bad9bae25b150fb0d60853989d2c4756630"
    sha256 cellar: :any,                 arm64_monterey: "24d0c3de81d5f8abd77bdd0bf284e4ed33adabc6b972cdb1b22e603a62909977"
    sha256 cellar: :any,                 arm64_big_sur:  "b33ca8f6daf19284cfbf3a4f399fd3df4ede76b1e354f4603d0bc3249d398531"
    sha256 cellar: :any,                 ventura:        "54c20afd155c5d6e0cad624df7ee31a77783dbb03625c81cf3ef2fa3a871c79d"
    sha256 cellar: :any,                 monterey:       "243e3f5ce4fac8ba4d4c77f770db463eee4bb19d9166d71bc3333fd32d762b54"
    sha256 cellar: :any,                 big_sur:        "fcf9cd21f141ed109b9da68e557ee97db294b32aa29cc4d1bd7e61797618ad7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13efe7f883516835a59bd9822826abae3b387c8f707bd64f67eacda1b3e5e44f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.6/bctoolbox-5.2.6.tar.bz2"
    sha256 "c33f8d80f01a4d40e013f846026e9d0c753e6f469284de370f4f1225faa01e11"
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
