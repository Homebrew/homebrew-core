class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.23/ortp-5.2.23.tar.bz2"
  sha256 "dc62f9f6e9155a453d439b4c1b6fa2e599012e89abc40e2206d189310055840c"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "48af35b65bd7b7a1ee20253998935dd16d256917ab22ad6582dc44936a521a70"
    sha256 cellar: :any,                 arm64_monterey: "6931b78dc013f3c368163ba06bc125ef9b5a007993afad14a1e5b47b15201240"
    sha256 cellar: :any,                 arm64_big_sur:  "80abcd20a58aa7686d32f9f609bd2838d0c83745327675820abc450c01f196ec"
    sha256 cellar: :any,                 ventura:        "360a651a0e4b6ca681f5572c8fec5407138ea45afacc15af0d14fe2938d57b41"
    sha256 cellar: :any,                 monterey:       "e836f3e354c1af2a09452282b58dadd7763934f499f369639ee61b591cc1927c"
    sha256 cellar: :any,                 big_sur:        "ef2a41d07138062584ae6013e5b9330b57b585fecd4c839ca99474c47c45ca4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018ed63c539f23be31911679b7660c101f94f2393593f652c090acbcb349f97f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.23/bctoolbox-5.2.23.tar.bz2"
    sha256 "6ef9a9ed98a48cc328bfede9f7a15a931036934418caeda5967456b88df694dc"
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
