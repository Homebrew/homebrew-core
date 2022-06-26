class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libXfont2-2.0.5.tar.bz2"
  sha256 "aa7c6f211cf7215c0ab4819ed893dc98034363d7b930b844bb43603c2e10b53e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "83ddeec421d8fe2eb3495608d9685cda2ab2da4a9d3972194f8a83f3ec6820a3"
    sha256 cellar: :any,                 arm64_big_sur:  "dd658e51a88632bcf96758a55bc40ac412b9dae9ba09d1d070c55f90901bdccb"
    sha256 cellar: :any,                 monterey:       "0c42b5f12cb49bcf04131bce885438578ea24e9f8bdfe841775d51ebf2a39947"
    sha256 cellar: :any,                 big_sur:        "607dc750c3f3cd66d73d00110c394a9834d0c694de5934733022961c681b6fbc"
    sha256 cellar: :any,                 catalina:       "58ea0e61969102d984913c1832fc88a2a32cff84a00a70b5de6178fc3998931a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1070ca317656349b712eac3509de1fed8e0c746ec1f076d5d0d8e10b65ca87ca"
  end

  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => [:build, :test]
  depends_on "xtrans"      => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    configure_args = std_configure_args + %w[
      --with-bzip2
      --enable-devel-docs=no
      --enable-snfformat
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stddef.h>
      #include <X11/fonts/fontstruct.h>
      #include <X11/fonts/libxfont2.h>

      int main(int argc, char* argv[]) {
        xfont2_init(NULL);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-I#{Formula["xorgproto"].include}",
      "-L#{lib}", "-lXfont2"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
