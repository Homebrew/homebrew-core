class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/0.7.0.tar.gz"
  sha256 "7a18e8096944a21e0d9fcfb389770d1e7672ba90569180cb5d45984914cedb13"

  bottle do
    cellar :any
    sha256 "d83539a5f07741571e46050c7fe444cd62ff0c8c51909a26e193e2abdd5ecd41" => :mojave
    sha256 "b5599742d6b369366a9bc00f42d6f3513cfb9c670bf6199222b7580c19c1706b" => :high_sierra
    sha256 "985afbb83ca67f6190f299ac8d22d929cc4b2bd12173954dab8d0ab4e7e485ef" => :sierra
    sha256 "4164c3d56b5b572d38f8f30d852e56a541b587f67c063213133842421302390b" => :el_capitan
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
