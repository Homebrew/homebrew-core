class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://nano-editor.org/dist/v3/nano-3.0.tar.gz"
  sha256 "3f5f7713665155d9089ffde814ca89b3795104892af2ce8db2c1a70b82fa84a3"

  bottle do
    sha256 "5276fda4dfb3454c34c5efe63d33b1817d1e8097a39a3c9fe2e0c909bf1c7b4a" => :mojave
    sha256 "18594f4be25300515830a5112cd5ea112fad9004c6651a5ace902603143a2ada" => :high_sierra
    sha256 "a5607cb79cc8b599b3a2bd368af2d037c17b62b03319152ef3f810a7aa40bc49" => :sierra
    sha256 "1ae56cb5aa66f4ec3d4a29c3dd5f1e0b1c9650a36278422ab497d224b4972054" => :el_capitan
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
