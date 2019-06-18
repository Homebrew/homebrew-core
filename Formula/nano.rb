class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.2.tar.gz"
  sha256 "c06e456890a93e7a61317a938c70caacaa2bfd6161a52b2731df83875ebbcf80"
  revision 1

  bottle do
    sha256 "a9fe516b43923e6a4214880e585444a5cc85fae01a7ea3635c134edea758235d" => :mojave
    sha256 "f59cab3a05fe138f2d04ca967e51a40cf78f397f4fc89719f498580b86559d5d" => :high_sierra
    sha256 "df3ab79f5a15e849597930370c7c0c71baf107142f0a6a0a4aae78b2f761d80e" => :sierra
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
