class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.2.tar.xz"
  sha256 "32c2da43e1ae9a5e43437d8c6e1ec0388af870c7762c479e5bffb5f292bda7e1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "54e6c2c5d89db89e86a198214c88eafa4b8bccb42d9219e71e54be83feaecff2" => :catalina
    sha256 "f576828dc01dc9d9edacc0d4dffa268b09fec85ada7375e6dc1e905d9dc95e6a" => :mojave
    sha256 "501092d0cd9e3e27af362473b236076c5ea127b3800c3184c747a5921f962f46" => :high_sierra
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
