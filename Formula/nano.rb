class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.8.tar.gz"
  sha256 "07192c320b74c1fb78437021e9affa6a9d55b806ee012de601902392eaa03601"

  bottle do
    sha256 "608c9d3ed1add8f4db86ac81cbf53d161db6be54d1c9f7186b3881633ed8dc22" => :high_sierra
    sha256 "c7ce7bee8e90bf95e0b4eb86f6cb09ac96ff13305244abb8abfc71fc99b1fe63" => :sierra
    sha256 "4bdec8ab585f7bdb26281f6dec332c995d15b16c00e0d536020e65b6455936d0" => :el_capitan
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
