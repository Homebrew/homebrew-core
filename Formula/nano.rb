class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.6.tar.gz"
  sha256 "3725aa145880223b2c4d0b3fa08220e1633f2d341917f49d028e067fc12cce49"

  bottle do
    sha256 "e77f5b3c877c2c35f9875915ee83ae14467cf70d7862bd3a59bb87dc302d43d1" => :sierra
    sha256 "3be1d0b7f071967470084cd301ce6600cd4b006e1b103d7d5c9d3295b8972621" => :el_capitan
    sha256 "233fc92c904683c0079b78649e030b045fcd1238648be9e4cdebf2338d9f1494" => :yosemite
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
