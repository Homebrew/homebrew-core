class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.7.tar.xz"
  sha256 "79f0b37c45007381c371a790c2754644ad955166dbf2a48e3625032e9bdd4f71"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8175c1f034681b3ad8f88c049e592a75dd7ed74da468e4b4abd7b0c6b92fa6b0"
    sha256 cellar: :any,                 arm64_monterey: "f564c302672356b6c5ff8748310527503b8586c4c62214f5ea6bfd37d072eb9a"
    sha256 cellar: :any,                 arm64_big_sur:  "2d3b436bec612143dd68c2d76e70f8193c4400ca0df95cbf4d29f19b1e6162dc"
    sha256 cellar: :any,                 ventura:        "d78514cadc16473ef16d6c2a3cf654f7435782b08720f965cb03c56f45f57f6c"
    sha256 cellar: :any,                 monterey:       "f0cc586372a1a2b67afb81965d741ab50453ba4d6dba97d73d701289a3d71e4f"
    sha256 cellar: :any,                 big_sur:        "2f40db6e5dc23843e700fa8b0ee995c7dfaa6ad1b2a2478fe5f834eaa796058d"
    sha256 cellar: :any,                 catalina:       "5724a911f3d4f07de517aee6da949f5705e8ecb8ad77e2bf2d64587cc8c7ca5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c64c26f48726bcf50db5be2e2b89d3a387f7ed08d840f48fd84e30210ed77386"
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
