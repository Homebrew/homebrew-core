class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/0.7.0.tar.gz"
  sha256 "7a18e8096944a21e0d9fcfb389770d1e7672ba90569180cb5d45984914cedb13"
  revision 1

  bottle do
    cellar :any
    sha256 "e7e8c680aa37026e42b554166fe30f19cc0e1d846726c673b12a70ae11689cb3" => :mojave
    sha256 "15c93fdb927969da990c764c5e37bb930b4f7a4eceffdcebb9713413029cac17" => :high_sierra
    sha256 "d3aa70f803b3818f64b2217a05d81d6e79eb475dbb1d4517c4fd45ea3f766259" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "pango"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "-o", "paps.ps"
    assert_predicate testpath/"paps.ps", :exist?
    assert_match "Ch\\340o", (testpath/"paps.ps").read
  end
end
