class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://nano-editor.org/dist/v3/nano-3.2.tar.gz"
  sha256 "ca694554628d6d5e695af70d3a78673a76b474c38732ab5bcca47d22845086bf"

  bottle do
    sha256 "7628abb16bd170c195f76e49f799041c4f0f89023f6b3099f9620359032ce492" => :mojave
    sha256 "2f5813de778b93cf4b5fe064ef4f4e5c93db76f3c1a6fd9c330341ba0519666d" => :high_sierra
    sha256 "9f89370b4a54053aed833cf3ab695a02f04d02198913aebe74d6a527eab0c61d" => :sierra
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
