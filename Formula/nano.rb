class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.7.tar.gz"
  sha256 "11c4939a5b9ba6627e57e2796c634e1f1e94063b7ce9cc7fcb7e99d2917196f8"

  bottle do
    sha256 "37692aaa6e40dc54e858c04aa0d78557205dc719b6e60cf114f3af41c725c72e" => :catalina
    sha256 "b73793db58a90b8a0a66011796f379be7cf7e6d3bfcae220a59d70e00d6c9ed2" => :mojave
    sha256 "95e7ea69b3e0fc0d980bcb5d9f6652fd2ffabf064da87c365a3304ebda982275" => :high_sierra
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
