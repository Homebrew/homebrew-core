class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.8.tar.gz"
  sha256 "07192c320b74c1fb78437021e9affa6a9d55b806ee012de601902392eaa03601"

  bottle do
    sha256 "1b7f5f7842d849709b209d48346bc2dc502b538eeee460ef63513775d82f70ec" => :high_sierra
    sha256 "0f14e7427708f6105143a6c03f962bf047f7162adfc1a9a7f67749d13a42614c" => :sierra
    sha256 "f2ec710b129cb095c1107a53c632c5009f8ecddb53db4b4b95eb08edca0037ae" => :el_capitan
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
