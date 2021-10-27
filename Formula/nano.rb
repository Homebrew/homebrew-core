class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.9.tar.xz"
  sha256 "757db8cda4bb2873599e47783af463e3b547a627b0cabb30ea7bf71fb4c24937"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fe7852eeca20f30bdc7b5bc11363dec0083cbea53e5e5c1298b5b644d5464f68"
    sha256 arm64_big_sur:  "9f74d4771f921ba8b96598ff34535334774646464fc0cb5cd9ea73bcb08cde23"
    sha256 monterey:       "2ad1ac998cfd3a137769aa0a9b5fb32127993a9f95d4ea66c1cb2f0e339bac9f"
    sha256 big_sur:        "fed1c216a7e0a13b7d1570e4b2425309069550dd6b4ebd6f4f5496763cbffb6d"
    sha256 catalina:       "fd5b65bf8dc3b4125ff5053a12c62f13657c2ee9a48e5b88dbadb36fa050652b"
    sha256 mojave:         "01a2a1ac57a8d98a806a60ca7c377f3708cc526dd033a1e593ce290419332f78"
    sha256 x86_64_linux:   "63a9579e3a59d6367e878c82848c4ee4add2aa770b759c4e0ada513a68ed6032"
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
