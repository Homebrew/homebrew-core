class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.3.tar.gz"
  sha256 "2b3b7f383a40899db5367d3c4e663ba0088868c0f9aa4edfd7457c9a0eedbdd1"

  bottle do
    sha256 "2dd39678afc4e9970b413e473d04ae1737f810b55694d04474c50a0634b44e6f" => :sierra
    sha256 "836b46088ae1b02105f1f44b41deb220a9ac1fa3fcd27e162ff9e4a4734667db" => :el_capitan
    sha256 "3b4bc9972840d85e3e2c83333289591e3e7ccb8c3d2a62145961cdf33aeb7ac8" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./autogen.sh" if build.head?
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
