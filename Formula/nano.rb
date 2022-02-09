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
    sha256 arm64_monterey: "9be4185befd0667d6f0eeb7e4ceb6f939f5c75bcfdcdeb6cb2a96257c0531ff1"
    sha256 arm64_big_sur:  "1e13818fb344b86e0a77c715e42f1c6ddea8ee70235b191054c2a64cd2359f47"
    sha256 monterey:       "306f9a86f78dac8d3650c9576d0752ac8de6eefc43f2164e265d0f335e51f122"
    sha256 big_sur:        "e3989960984cb26656c493dc9444b58b4785354214de294e83bc944dd05da736"
    sha256 catalina:       "eb71bdb96fd7bc39a00be9263b63d04114a6d939281d2a55bcd18736b83b220a"
    sha256 x86_64_linux:   "0f4bb9643dd542f6ac784917589b004f4e75eca55f1c4ea3a0366f03956d12aa"
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
