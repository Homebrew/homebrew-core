class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.5.tar.gz"
  sha256 "620290467d5340448b728fc7535418db18edac661cf8f95bccc74d768b2614d0"

  bottle do
    sha256 "c2b11f274f05fd47c54712a199f5f2714c8d176c85a535723a1e0240b547a095" => :high_sierra
    sha256 "1ec561f8084e1ee2297923faef532c62ffdd7b12bf59046eae01b894c7c02642" => :sierra
    sha256 "644d6ebf2a6d4001791ba39b9cb10dd82d00a117da6468e69eb12cf4b9942262" => :el_capitan
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
