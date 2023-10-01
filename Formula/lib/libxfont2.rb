class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.6.tar.gz"
  sha256 "a944df7b6837c8fa2067f6a5fc25d89b0acc4011cd0bc085106a03557fb502fc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9b460431534eaf8a4fc608aee15a4c6280a969dc41790a57074022aec30eb1b7"
    sha256 cellar: :any,                 arm64_ventura:  "44da375c2fc8bafff763cfb2dba910dd678f57cf6ce2aeba8fd72e4fbb86c869"
    sha256 cellar: :any,                 arm64_monterey: "09e50cb913e815ea32277dc0ec23e310bb6d4731e90e3412e9ee2affb5a262ae"
    sha256 cellar: :any,                 arm64_big_sur:  "561f79f169796b4a1efa9e2d16ca265f4953d4a1f2cb6be6c8a27ad8304f5fd6"
    sha256 cellar: :any,                 sonoma:         "2337adff049134c0599e19b96e9e11a685c24d0d97d5541cde98b04cc39a99cd"
    sha256 cellar: :any,                 ventura:        "f94e0374fabd345c61bf9f1e075df63a3f463031dd50c3122993f839b6e0aa91"
    sha256 cellar: :any,                 monterey:       "c4b1e0ccbbe516996d172865a1800982d2da702ffdce524c622e657fba52d066"
    sha256 cellar: :any,                 big_sur:        "141d3bd006ad7bd579d4831694331cde1c53f6ef1c62c34c6ed14cd9143c948d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35a40dae3956a3956ee2866692dcc600b659495599aa5f4ff4f42718d74ad777"
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
