class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.6.tar.xz"
  sha256 "60a6e7319fc938bbb8d098c9bcc86031cc2327b5d086d3335fc5c76323c03022"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9a556798787320a42074ac9d686c92cc3a725189687982983c9b6061d3aa88dd"
    sha256 cellar: :any,                 arm64_big_sur:  "11d419ebb84ec33ffc6ed6933e07e7ca199f35789137a4c52673cb21901cb322"
    sha256 cellar: :any,                 monterey:       "3dfaea043c692c740bc13def8d42e6a3416a75cbacde5d9f7566cce325830d4e"
    sha256 cellar: :any,                 big_sur:        "b3ec3c8aca9ed18ef953c922203be5151215d7d2e469fb8a856924d96dbdcb8f"
    sha256 cellar: :any,                 catalina:       "a19ddf4fb1de2c697f71766f72c333506500c3dc27308f14cdbe0ef861248c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f946e1cc8b34acbc64664af6c3c5a987f1eafadd29d081925e3425675c311689"
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "libxrender"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xft/Xft.h"

      int main(int argc, char* argv[]) {
        XftFont font;
        return 0;
      }
    EOS
    system ENV.cc, "-I#{Formula["freetype"].opt_include}/freetype2", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
