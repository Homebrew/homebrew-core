class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.5.tar.gz"
  sha256 "7abb2c2eff69472520becbde4d9421349639cc1cc47f4756ad36c3a66836e52b"

  bottle do
    sha256 "c0de36667c8625b139fb70d88cd2e65b9c35d37458e74106728cd19901d13da1" => :catalina
    sha256 "bab12ab8b772535228cb864cca59a2a97b2d0fdcdaacc902fec775ab82816ac4" => :mojave
    sha256 "8dec7b716b1cb9e08cf75a951e6571301bc1d60666b5d84efd595083c395d17b" => :high_sierra
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
