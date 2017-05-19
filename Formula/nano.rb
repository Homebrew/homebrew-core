class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.3.tar.gz"
  sha256 "2b3b7f383a40899db5367d3c4e663ba0088868c0f9aa4edfd7457c9a0eedbdd1"

  bottle do
    sha256 "38372fff75ca521e6f7025fbfc6f487dda312de2cacda331f64a2b231df734c7" => :sierra
    sha256 "7bb8396e281bf5881fc0841991b3c0073bec5603f14b318a4962f878d09f1f2d" => :el_capitan
    sha256 "023213aa3a2dc6f5bdb107e968c55acb0d54faa29d6f13a714c26219b47ce37d" => :yosemite
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
