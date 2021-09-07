class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz"
  sha256 "ea566e528605befb830671e359118c2da718f721c27225cbbc93858c7520fee3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/gperftools[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a8711aa1a9496a1c801b10bcfc3572fc204be3af52f2455a0a3d9e1b2d924aae"
    sha256 cellar: :any,                 big_sur:       "db13bfa856a699c5e74e95ee81722cc76b38bb9dcca1d10cebe2eed17888ff68"
    sha256 cellar: :any,                 catalina:      "df9901c12be430101b403c8024a4dc5b5f5d0f718e4ace970f52bc68b17a3659"
    sha256 cellar: :any,                 mojave:        "9976b82f86958d3ad6924d138d138d5bddbc2bcc6eb16ea44c4255ed9cb889b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35bdc71ea25b996acec0752c3dbb6a68b1f56529f577f08f1a32556893ce70ca"
  end

  head do
    url "https://github.com/gperftools/gperftools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "xz"

  on_linux do
    # libunwind is strongly recommended for Linux x86_64
    # https://github.com/gperftools/gperftools/blob/master/INSTALL
    depends_on "libunwind"
  end

  def install
    # Fix "error: unknown type name 'mach_port_t'"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    ENV.append_to_cflags "-D_XOPEN_SOURCE" if OS.mac?

    system "autoreconf", "-fiv" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]
    args << "--enable-libunwind" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltcmalloc", "-o", "test"
    system "./test"
  end
end
