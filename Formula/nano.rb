class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.2.tar.gz"
  sha256 "c06e456890a93e7a61317a938c70caacaa2bfd6161a52b2731df83875ebbcf80"

  bottle do
    sha256 "c60bcaca918c69ed39f552fde9c271bfb2409cc63ce2f3ddf1b4e302d01a8eaa" => :mojave
    sha256 "d601f2fc6cbfc61ee0346cca60a538d6782b9a97992fe879ab148d0e47a2df52" => :high_sierra
    sha256 "01da439fc484b0935b10d3f29f55d2af29d511b90695491a25179437cc1572dd" => :sierra
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
