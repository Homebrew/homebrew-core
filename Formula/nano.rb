class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.5.tar.gz"
  sha256 "7abb2c2eff69472520becbde4d9421349639cc1cc47f4756ad36c3a66836e52b"

  bottle do
    sha256 "91490cfb6968dddc3aff262a613e966c1026546b93c928b49d6f9d33e8b15e6d" => :catalina
    sha256 "a73e1d99c87c8939b7755baeb08550310c8201008329cedf165be69d2122632f" => :mojave
    sha256 "b02ce36834b6b4c987d9129a4158ea21628418b913e3af8a7eb083cee152e40e" => :high_sierra
    sha256 "11ebb8fcd5581718b64c87dd2378d8b3f716d0dc113586b2211029a53d88e8ae" => :sierra
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
