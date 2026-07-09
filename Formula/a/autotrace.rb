class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.net/"
  url "https://github.com/autotrace/autotrace/archive/refs/tags/0.31.10.tar.gz"
  sha256 "14627f93bb02fe14eeda0163434a7cb9b1f316c0f1727f0bdf6323a831ffe80d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  head "https://github.com/autotrace/autotrace.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ab9f30deffcfe2b3eadbb7a1483f29f5ab1fff7bf4518d0ecf9062fa2839d39b"
    sha256 arm64_sequoia: "b36ba642259814567ac88161df1330c8e1e1160d0022eb0ff8556992a9ff6c0c"
    sha256 arm64_sonoma:  "b9725af1513a0da94e283765802022e0e9ae80b0d785a0d5c78da4981a16496e"
    sha256 sonoma:        "e4d9f47afb4b508a32cbcb02bcb2266c70bc15103337a502c1a5b0b064a1ff8a"
    sha256 arm64_linux:   "55965727c03a1092493b6e0affc35fcebd8a86e2a4d74b928c9b931ca03ede47"
    sha256 x86_64_linux:  "b8b573bdd4ece3b522e921a559424bea53474d39b7d0b6484a0719a9c6653f53"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pstoedit"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./autogen.sh"
    system "./configure", "--enable-magick-readers",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system "convert", "-size", "1x1", "canvas:black", "test.png"
    system "convert", "test.png", "test.bmp"
    output = shell_output("#{bin}/autotrace -output-format svg test.bmp")
    assert_match "<svg", output
  end
end
