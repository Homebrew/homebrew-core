class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.109/ortp-5.2.109.tar.bz2"
  sha256 "cb8bca162410653e0f42b42df62e34ac9d6f4f686ac13aaaaacd8af2b2649c72"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80e8c5ab495ed6d5fedc7d82db7ea15647121f509f0ae7fa694ca988e47cd8cc"
    sha256 cellar: :any,                 arm64_ventura:  "c3fb60404b2ee47b7af4603a4bc63718f31d3ee3e9962358467f8b36ce8c361d"
    sha256 cellar: :any,                 arm64_monterey: "fd4d888c27663653df74e26402ad6603e2a9143e93597a117918c6f16a571ac6"
    sha256 cellar: :any,                 sonoma:         "69e43da6c8c2bafb7dbba2c9d094f5c06df8b4e05e49df9c832bacb5969e76a9"
    sha256 cellar: :any,                 ventura:        "8b84c507b6b030854df171e95c1088d9b02cb3332f75b70efc4131a3c6c481f3"
    sha256 cellar: :any,                 monterey:       "193f4172bbe729856f70fb00f6964cc0bdf261ab6bbbe670aa1af33848e8a3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2317842dc17ea632db3a86fab95aca701ae5abe61c3a22fb605086abceaedee5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.109/bctoolbox-5.2.109.tar.bz2"
    sha256 "bfa719cdd154c0f5d2f6e1c8551fbb285cea8e7ecbc5133d10bba37c3ce40544"
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
