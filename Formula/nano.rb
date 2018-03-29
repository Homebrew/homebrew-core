class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.5.tar.gz"
  sha256 "620290467d5340448b728fc7535418db18edac661cf8f95bccc74d768b2614d0"

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
