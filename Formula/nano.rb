class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.6.tar.gz"
  sha256 "4ec0a0196914a7665572bcd8a32d76535ea19a8213ea67cf8f63e8ce566b1e0a"

  bottle do
    sha256 "457885aa6c8c26084f35ec111a7acdd70494d3e694532dfc0c1c3d8dbd7ff5cf" => :high_sierra
    sha256 "72d7563e10af34d79363f865a053575903d2d991408f061013a3de8ff459a966" => :sierra
    sha256 "9ed7f4595a62a48981364e172e0acd995ef8f26f571aa841b88729d38638107c" => :el_capitan
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
