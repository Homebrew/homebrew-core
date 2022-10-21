class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.66/ortp-5.1.66.tar.bz2"
  sha256 "288d6f8e0adc2993faff3fbc69cd00e2a7acacfe7b078580c68b8840bd368ba6"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2cb4c5113c8abf52205439a794dbfb4afc0463e0ebe639ff4c3f38fe3d0b8eee"
    sha256 cellar: :any,                 arm64_big_sur:  "85f95ec897c535f2d757379fcb72d54b280713f5d651112ed6fddb36ce1af601"
    sha256 cellar: :any,                 monterey:       "cd58de6d098a3821952e6181b389a686049ddb7a3b9d7c681eca50d4e670b20a"
    sha256 cellar: :any,                 big_sur:        "737d90f231d15064067f3061f240697f0026940b3777e7f537aa375ecb6345dc"
    sha256 cellar: :any,                 catalina:       "d3787b7fda140356172c31fd392a6f3c62ce8b3739a1c6a135fa4b75366430cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9a1ff48f9efd5842e9352cfef03da292306262af844156789001922b3e7c9bf"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.66/bctoolbox-5.1.66.tar.bz2"
    sha256 "bda99d3d245cba5e49c462213d6748c43202536007cd3d83147134bdf7020f72"
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
