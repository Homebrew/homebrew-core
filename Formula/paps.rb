class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/0.7.0.tar.gz"
  sha256 "7a18e8096944a21e0d9fcfb389770d1e7672ba90569180cb5d45984914cedb13"

  bottle do
    cellar :any
    sha256 "180eee4688d9289f750afb0b4f763612874c7a42f2bea7ffb228a2e51f4681b9" => :high_sierra
    sha256 "8fe4408fc505e10a6fabd2d78e7fcefb33cccff53f8f404732771e3249509fb5" => :sierra
    sha256 "2a1f0244a125e9028a1d4b99fb45eec5793bc96834696fdbef823fd801c91643" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "gettext"

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
