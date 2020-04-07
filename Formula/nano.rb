class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.9.2.tar.xz"
  sha256 "d8a25eea942ecee2d57b8e037eb4b28f030f818b78773b8fcb994ed5835d2ef6"

  bottle do
    sha256 "780e5527560d6abf3451268e7dea82d967e2ada16af876515ee0a854df9d66ea" => :catalina
    sha256 "08e655ffa3322c2bff3d7923724cc23516b3edb4bacbcbc939d100bb795d122b" => :mojave
    sha256 "579f36872516d5a73f5d09a96bb97d7ec54acb612f1d8cf2f65d2572e0f9596e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
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
