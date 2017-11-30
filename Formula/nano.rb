class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.1.tar.gz"
  sha256 "41650407cf1d4b752f31dc05e7c63319957e3dc86e9fb6ad51760e8b36941d19"

  bottle do
    sha256 "3fe69fb09bafdb964b8613d718e9bc523bc3e1d69ffa0f7ec37d96ab1ccc41fd" => :high_sierra
    sha256 "8f8c1f081647392ff41210eb263604e27e9a7b43c558bd1b9fa1211bb1f2eac7" => :sierra
    sha256 "03dd7ce0bbc8383e7234f55aefc7416974d0d1397cfe4dc45044c2aeb6e9089c" => :el_capitan
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
