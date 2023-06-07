class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.64/ortp-5.2.64.tar.bz2"
  sha256 "2706d0ba39a75106f4286837dbc5e4827960d59ecf3bd95d71c8d5b1ecfb70fd"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac83a762971de32dec46ccba35d7d8ce9f0cd52c136b33bfd7a587457a54f19d"
    sha256 cellar: :any,                 arm64_monterey: "d7aef89e58beecf4d96511e8e36bb1402ea9053b3f4ed51cfdc2da4a30aa5ac3"
    sha256 cellar: :any,                 arm64_big_sur:  "ef810441d0e6af68c67673bdbd90e10a8a99af022b485d43438f5d31aaec88e0"
    sha256 cellar: :any,                 ventura:        "2b95010a5200336740555fde757999d6b6b1e6984de6f9d5576e8c77337c3bf1"
    sha256 cellar: :any,                 monterey:       "68e39ebf424f0a211716c71a93238aeb7310e8bfae0637329be7478e1bdb9c08"
    sha256 cellar: :any,                 big_sur:        "6a12aadb3ae44b942258408432002f30933ea6dc411ac46caffac9aa60d198f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71560383a9d5ffa10686451064beb72480e7947dc5178336e06eb9c334fba3de"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.64/bctoolbox-5.2.64.tar.bz2"
    sha256 "a056f4db62a1ddb6fce9d8b36186b40af3b3ca59cf7748997744a646e6ad25d2"
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
