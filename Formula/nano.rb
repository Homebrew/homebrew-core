class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.7/nano-2.7.4.tar.gz"
  sha256 "23ffc2de52d687739fed6dc2fc94df36aa7da7bb52c8740c523fdd7336fdbc8c"

  bottle do
    sha256 "b9b7985beeaab3ab7ecb03d563c9aab3c4372ccf127ff26f78e8ce8f94ec41b3" => :sierra
    sha256 "cb4245a64555d0a869266d6106dbdf055a3e8b02a2b3be212beda99a2f310978" => :el_capitan
    sha256 "4fc26e6b0d647bf705a15c0d74aeb667ec70b2da177c7005b8a53c2da7c21b6d" => :yosemite
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
    # Otherwise SIGWINCH will not be defined
    ENV.append_to_cflags "-U_XOPEN_SOURCE" if MacOS.version < :leopard

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
