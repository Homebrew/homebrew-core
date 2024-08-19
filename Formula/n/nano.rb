class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.1.tar.xz"
  sha256 "93b3e3e9155ae389fe9ccf9cb7ab380eac29602835ba3077b22f64d0f0cbe8cb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "10736cd31e7deb0c856686ad34749712c93139d113cc6ee7ff0e2933cc27bd5d"
    sha256 arm64_ventura:  "4f1578b28234d5314c37b8b748d7d0148d5e6ef800b92eebd218d6f8e47c3695"
    sha256 arm64_monterey: "9acb46fae45e2b4a45dbb6a5be2916126e368fd15829b921eb37f887c5c29298"
    sha256 sonoma:         "78947cd54c0938695fd01dd784f3f0033c0af053262712e2d34bef6cd7653513"
    sha256 ventura:        "316540a092fbebe1630afa5f4fe88441ad6198a53c6a06343fc0bc1f02f7f89c"
    sha256 monterey:       "0ed2dbd68bad1847f1168a050e293f541f5edd3b49ffd3fe653d38a2a7d11b3f"
    sha256 x86_64_linux:   "a6f2a482e8deedbbe027c63d0b92ad4b78d4911400f9c59aa1166517c9db52ea"
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
    system bin/"nano", "--version"
  end
end
