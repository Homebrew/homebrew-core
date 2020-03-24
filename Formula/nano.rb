class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.9.tar.gz"
  sha256 "20fab3ba591eb04d6baea55dd1274d8558ea0f3e59470e25d15cf06dda760e58"

  bottle do
    sha256 "05196b3073fe9e0b5e1600d3db27e847c8bf04eeab969f499179b6ea452da567" => :catalina
    sha256 "1be27284872d9f4db82cc044330eb7bef46f57f4a450e6131fb96d5249a69de0" => :mojave
    sha256 "dbe19cf80ab30346aabc10e5137e4e83316d7fe89bdeccc363fa942079b04921" => :high_sierra
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
