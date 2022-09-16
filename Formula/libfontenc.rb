class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.6.tar.gz"
  sha256 "c103543a47ce5c0200fb1867f32df5e754a7c3ef575bf1fe72187117eac22a53"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1702ab755edeefdc9cf36a96083102cad9f031db459d5d520013ba5e3d3a7d57"
    sha256 cellar: :any,                 arm64_big_sur:  "672d73aa82907db7954f09fbacee489a7e0cfb8de53000f76cb0ca5b42a7c494"
    sha256 cellar: :any,                 monterey:       "defb274f7857f09d3df493d44e9deddcb98e3adf11e6702072ebf467589c51f6"
    sha256 cellar: :any,                 big_sur:        "fe8c98d47e6a7fc8eb0ed31e227f6de34542e4abb96e8240a8056346a041106a"
    sha256 cellar: :any,                 catalina:       "e5aa804c290150835e12655cca2de2046b56c1045e5ebd17743cc41b6d15456e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "007491088ac92cc2a280b1ccb7d142a9d7e8ab3eae987314d9ef68e5dfd47eeb"
  end

  depends_on "font-util" => :build
  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
