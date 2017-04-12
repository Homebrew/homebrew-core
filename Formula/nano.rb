class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.1.tar.gz"
  sha256 "a48650dab5fc069bb953d020721b6c0f650969abf5a34a27dfd6f038215c5910"

  bottle do
    sha256 "411a3a863a10702240e28408dda94d1b0982d914c0e180fd9c21907b9c505577" => :sierra
    sha256 "d35090367469708b482ecb2541fb6509376bdf3953bb7c7b5bcb7f25c7a1f34f" => :el_capitan
    sha256 "6bef87c38f8d3d04f94ebc2bdf9cce3c1eeb0492fca20c94ac007923fea3bbbb" => :yosemite
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
    # Otherwise SIGWINCH will not be defined
    ENV.append_to_cflags "-U_XOPEN_SOURCE" if MacOS.version < :leopard

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
