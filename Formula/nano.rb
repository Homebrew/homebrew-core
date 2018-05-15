class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.7.tar.gz"
  sha256 "9c7e1fe68a125a5f6e9a1118bb4928184124381dc80646714c86874964d92217"

  bottle do
    sha256 "48c72640410fec697df32b1a1d349841c157685d4060cceb1b31d21cb5535b7a" => :high_sierra
    sha256 "117573cea6487f6346ea205b56f861893c507f2e50054f8a41e9343bf424336f" => :sierra
    sha256 "c641678d4991639c515e3162e54f2a501fc9553bd8c4c52bf92e74fe831e2028" => :el_capitan
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
