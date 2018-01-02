class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.2.tar.gz"
  sha256 "1ed3c61100181bebb2bf60d60a44a3b9658410cbe05f375f7b3814b2973c8fd1"

  bottle do
    sha256 "87e5ec4ff6dabd259139dd4a6c7977aafd39583063f57a70b579b907740a7f4f" => :high_sierra
    sha256 "038973caa98da42bd6a428fef97aeca0f50241e95d9ce3210c55d33f31c7dbca" => :sierra
    sha256 "7e7b88ef39fa11b16014cd13866a25da27694e9d4583906b1c1ff9f4f49bf16c" => :el_capitan
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
