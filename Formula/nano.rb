class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v6/nano-6.4.tar.xz"
  sha256 "4199ae8ca78a7796de56de1a41b821dc47912c0307e9816b56cc317df34661c0"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7206f1c20ac7fb4cec10b80b56d41177de74a7d2555119260353dfbcd0f6dcee"
    sha256 arm64_big_sur:  "f934bf0fdbad886af747aae1f4a170ae81eb8ccbb589f5336f979f372d54dc29"
    sha256 monterey:       "9990a38a504f0e5870b5f2cbee431bed3d8cf4a5d37574667204222de5909644"
    sha256 big_sur:        "b2155541903136e636b0278100abe08de6789d116d3447e200c2b64f38502c8d"
    sha256 catalina:       "9b8e2dc90064352b3dbd1d6c2ed7b7f0f3fbd8729c6e56de92ee141d5ad4734f"
    sha256 x86_64_linux:   "1b62f99721aa78fe835fe6efb676e9f01b391c8fcdcd0aa4297b11ba6e15f145"
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
