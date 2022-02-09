class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v6/nano-6.1.tar.xz"
  sha256 "3d57ec893fbfded12665b7f0d563d74431fc43abeaccacedea23b66af704db40"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a73c19c70a958214296f76a0afa3800d3b5831f2c053db1029e6e0e0d62c536a"
    sha256 arm64_big_sur:  "e5f3cab412cdb28771d6fd13eab01497aa63f31e4593725f5068bcc850479d50"
    sha256 monterey:       "7fda29550eb1c5199983b8dbda2ceb4aecd08f5b553ef06e76ee764411cdb430"
    sha256 big_sur:        "9db19e13bf4e3886576e68def35fe32ab7edaf7801b4e70b979f30fd100cb72c"
    sha256 catalina:       "e0b260c71a8ebd46dbe1a065b093e652e73842a0ef4ee4de31d88f6a28c06357"
    sha256 x86_64_linux:   "db46dd37a8a2c2177c7e8505b232da16ccf69e9fcc98a807b7117bef161f6be0"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
  end

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
