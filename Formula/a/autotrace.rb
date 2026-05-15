class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.net/"
  url "https://github.com/autotrace/autotrace/archive/refs/tags/0.31.10.tar.gz"
  sha256 "14627f93bb02fe14eeda0163434a7cb9b1f316c0f1727f0bdf6323a831ffe80d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/autotrace/autotrace.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:    "8f46e9bf0a5498be353f53dcfb86707921065ab3b96935e90e270aa98202520c"
    sha256 arm64_sequoia:  "c2d1d03bc042ec69198132771c0f609e20e53bb2902ae38318803ad22a642dd5"
    sha256 arm64_sonoma:   "bb7e5e2c27bd3da06e535a8a06baa26600dd95e864e18bf8600a2aba988069ad"
    sha256 arm64_ventura:  "d976e8f28196b677548bb11fee10be185632451b5cd5a8d1b0d4752d052118b3"
    sha256 arm64_monterey: "f75fb3dec8f93b6cd85ba5520010a28103a0c9259f0f4321691651f9b2f5da0f"
    sha256 sonoma:         "309ada11b08e9bb6477127ba861acf1ea44e2a9c4e4ef366a614d418d7c8ef55"
    sha256 ventura:        "1da418dcb2e3c56b24a46541728782d9e2853f9d9988f3146c151016dd7c86c6"
    sha256 monterey:       "21cbef75c9802414f576566503a5d570e878fbaf0d2587d40ce5773371866ab0"
    sha256 arm64_linux:    "2b49716451cbac5e13837244a3413197cc69e0d5358e519697d104e667f5ac4a"
    sha256 x86_64_linux:   "4aab08802d48a33cc4d89c858fbc7ecc61dddb7a8d1e6ec250cf8b2dda4b9f8f"
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
