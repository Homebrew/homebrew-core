class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.2.tar.gz"
  sha256 "c06e456890a93e7a61317a938c70caacaa2bfd6161a52b2731df83875ebbcf80"

  bottle do
    sha256 "ac94340edf8159d0a5b6ae36f3176fe364d7c58bd976a90a41b9cde91e60e231" => :mojave
    sha256 "59282009b7a5b3ae393ebe71327b47827bd88f7f6d04d38a4569109ccffdacce" => :high_sierra
    sha256 "709bd58771764b3b96c058262b7271d82833fe6bc4a6cfd0f19a67848d36e855" => :sierra
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
