class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.2.tar.gz"
  sha256 "1ed3c61100181bebb2bf60d60a44a3b9658410cbe05f375f7b3814b2973c8fd1"

  bottle do
    sha256 "772e4fc5acd35f6fdc26be630ae486bb32d47890fb2321e78a64b3fad3a17a70" => :high_sierra
    sha256 "edb33a760e426f2ec44a72b18ecc3659e3217c49d8f2998731c1c81a98817a80" => :sierra
    sha256 "a830d7099a6c009c6586a37ded6f519c1c9fc052c40b69b95473cf53e3a4d86e" => :el_capitan
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
