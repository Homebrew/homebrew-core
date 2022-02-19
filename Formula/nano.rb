class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v6/nano-6.2.tar.xz"
  sha256 "2bca1804bead6aaf4ad791f756e4749bb55ed860eec105a97fba864bc6a77cb3"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5b3590d6a17c81459809cdc2943a56bb779b97d703fa592d5236eff789fd9103"
    sha256 arm64_big_sur:  "82226cbe2b0b909aa6c33d1abbb8a2562df36029058012d7dc54779e10dec336"
    sha256 monterey:       "1156f0aaaf6dd4952ca5238987de4f78b2030f5eddfd5895b07ca340799db3db"
    sha256 big_sur:        "1f82dc14c291e0cdce4040268f2a12759be3e506a880e11894ef1d0b7d662549"
    sha256 catalina:       "d35a6aa34fe8d1e7864028d96243c18ef900f37cf0241952058b0ffe6d746dec"
    sha256 x86_64_linux:   "858c7ccf4e05e4f726c71ba6cfdd76d8055a94920ec84d47262c0bbddaf7fd66"
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
