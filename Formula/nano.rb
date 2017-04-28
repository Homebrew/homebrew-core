class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.1.tar.gz"
  sha256 "a48650dab5fc069bb953d020721b6c0f650969abf5a34a27dfd6f038215c5910"

  bottle do
    sha256 "c5b98efd0f358755054cfbaf63ec66f8aa23a7c68214151dfef11f80d387b615" => :sierra
    sha256 "4f9790191389775592d70aeca0aa85e040f12afde2df210bf0c04be34767dc45" => :el_capitan
    sha256 "b0401e6cd4b1079ccc9943b775429b89c8f7e77c4a2fffa94e79db525c61ea79" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
