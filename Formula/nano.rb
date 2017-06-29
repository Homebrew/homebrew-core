class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.5.tar.gz"
  sha256 "e2b929b24fba87f7a44285ce8d47af7170e379bee1bf2d04fbc728b7326a558a"

  bottle do
    sha256 "fbbfa6d9ff806ae0d8fd5d3ce4859cf9384ef3a8c58814c7132dd062a1e9bc20" => :sierra
    sha256 "e7e4cd0d6ada051281a11da9c5bf861521acd0915d9545cebe7d61b2dd0cb2d0" => :el_capitan
    sha256 "4cadf2251857934a5a353081818c66e7f76811932e2df5229ae5d2610f7def14" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  # Fix crash from usage of %n in dynamic format strings on High Sierra
  # Patch credit to Jeremy Huddleston Sequoia <jeremyhu@apple.com>
  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
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
