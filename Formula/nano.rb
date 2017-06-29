class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.5.tar.gz"
  sha256 "e2b929b24fba87f7a44285ce8d47af7170e379bee1bf2d04fbc728b7326a558a"

  bottle do
    sha256 "4221d156c06c06db498f2fa8611a6c2d4240c9d3a7bb83d223e7b80c4b07863c" => :sierra
    sha256 "54e9896910b1648d62dd9626ce9dbf4c2ddf32c1bc4553e4a1595b4c68d5c7b1" => :el_capitan
    sha256 "e13762936882ec05b44f38011a19dbab29f4d70b81e49a9e27ed5af7c576db4e" => :yosemite
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
