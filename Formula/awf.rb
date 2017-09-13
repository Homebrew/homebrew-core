class Awf < Formula
  desc "'A Widget Factory' is a theme preview application for gtk2 and gtk3"
  homepage "https://github.com/valr/awf"
  url "https://github.com/valr/awf/archive/v1.4.0.tar.gz"
  sha256 "bb14517ea3eed050b3fec37783b79c515a0f03268a55dfd0b96a594b5b655c78"
  head "https://github.com/valr/awf.git"

  bottle do
    cellar :any
    sha256 "bbe56879c4de58ef832bb6ba45d07555eaf481ccb2fdafdb627ed0598ef0c3dd" => :sierra
    sha256 "191615297091a381c7d5ac0b3702d936ef41c50fbdfec153df00369acac53106" => :el_capitan
    sha256 "6b9e3490b4f19691535979787ff5d586c6781061bfbb26dbcbc731d64eb5f13b" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk+3"

  def install
    inreplace "src/awf.c", "/usr/share/themes", "#{HOMEBREW_PREFIX}/share/themes"
    system "./autogen.sh"
    rm "README.md" # let's not have two copies of README
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert (bin/"awf-gtk2").exist?
    assert (bin/"awf-gtk3").exist?
  end
end
