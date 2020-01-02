class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.7.tar.gz"
  sha256 "11c4939a5b9ba6627e57e2796c634e1f1e94063b7ce9cc7fcb7e99d2917196f8"

  bottle do
    sha256 "e9bc20edf4cb803e19698c852c04b16fd80aa65cc13dd038325118ef9e030749" => :catalina
    sha256 "c45f47c1154978ac59410cbda1da83fa76d58b9ad13fbdbed0b6d6e721b6fe77" => :mojave
    sha256 "1c09e84ea1a05180a5acbd56f0f738bca4742f9cc834a0586685d47f59c57902" => :high_sierra
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
