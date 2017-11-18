class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.0.tar.gz"
  sha256 "220cdf0b29b3d2bcba66e7aaa5b27ed1f2bf53c44192d8e0e0328624da3dbebf"

  bottle do
    sha256 "831b7c3e751dff9bce0e874e2f650e0e02cf556349913e94379dc9aaed8b3c3e" => :high_sierra
    sha256 "5b84f256231301bddf7e079cbd2845ce12911ef0c9dc05870e5c50d86babd5c8" => :sierra
    sha256 "2ab25ffe79af65eedc41445497600c0a5723c2e196886155f9f5beb0f5eada92" => :el_capitan
    sha256 "8ea801434cc2dd837f5a0f147030d850106d26ddf9740d97f23e6275ab57222b" => :yosemite
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
