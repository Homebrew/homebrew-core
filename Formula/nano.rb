class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.1.tar.gz"
  sha256 "41650407cf1d4b752f31dc05e7c63319957e3dc86e9fb6ad51760e8b36941d19"

  bottle do
    sha256 "87e5ec4ff6dabd259139dd4a6c7977aafd39583063f57a70b579b907740a7f4f" => :high_sierra
    sha256 "038973caa98da42bd6a428fef97aeca0f50241e95d9ce3210c55d33f31c7dbca" => :sierra
    sha256 "7e7b88ef39fa11b16014cd13866a25da27694e9d4583906b1c1ff9f4f49bf16c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  # 28 Nov 2017 "stat: fix compilation failure on macOS Sierra"
  # gnulib commit http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=commit;h=cbce9423af01902fde4d84c02eedb443947f8986
  # nano bug report https://savannah.gnu.org/bugs/?52546
  patch :p0 do
    url "https://savannah.gnu.org/bugs/download.php?file_id=42510"
    sha256 "a07c826502b119113be3a376fac1c0be8e07f2b29b0a201ee95b2678317934dd"
  end

  def install
    system "./autogen.sh" if build.head?
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
