class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.7/nano-2.7.4.tar.gz"
  sha256 "23ffc2de52d687739fed6dc2fc94df36aa7da7bb52c8740c523fdd7336fdbc8c"

  bottle do
    sha256 "87672dcd3b034ec2b8d19b3497d4d661a53c216414de1a50f80b2842020725dc" => :sierra
    sha256 "612cc5c65432e26bef06197b7eeda194f7b42fac62be6e835808c90c52e9d893" => :el_capitan
    sha256 "7eaed3b3541993a829d1ae17642d9d5b67422150ea6ee719fddbeb675dec816d" => :yosemite
  end

  head do
    url "http://git.savannah.gnu.org/r/nano.git"
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
