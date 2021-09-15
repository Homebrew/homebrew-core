class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.8.tar.xz"
  sha256 "e43b63db2f78336e2aa123e8d015dbabc1720a15361714bfd4b1bb4e5e87768c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6178715c7ad2ab86dcf43d59442af4e5fd9ddc65041934329f53f7a31a261eec"
    sha256 big_sur:       "39c0fdeb6069c928f0a71b9affa20fcc330ddf55e1f39178cf246a0a3806830f"
    sha256 catalina:      "f48cedf405592c2e8479b26ff199a1ce339a97b511eb7afb368e638f7e09f5b6"
    sha256 mojave:        "450b2c6435a9e91d32b2c7caca61b800bb2d8ccf8218bc7c58a4e0d0b7e3efcf"
    sha256 x86_64_linux:  "05ff586576fe27da161ac36ca18c272a378ec842440525011f8f87dded0e766c"
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
