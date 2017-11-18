class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.0.tar.gz"
  sha256 "220cdf0b29b3d2bcba66e7aaa5b27ed1f2bf53c44192d8e0e0328624da3dbebf"

  bottle do
    sha256 "3fe69fb09bafdb964b8613d718e9bc523bc3e1d69ffa0f7ec37d96ab1ccc41fd" => :high_sierra
    sha256 "8f8c1f081647392ff41210eb263604e27e9a7b43c558bd1b9fa1211bb1f2eac7" => :sierra
    sha256 "03dd7ce0bbc8383e7234f55aefc7416974d0d1397cfe4dc45044c2aeb6e9089c" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

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
