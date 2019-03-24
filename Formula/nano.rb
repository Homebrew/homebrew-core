class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://nano-editor.org/dist/v4/nano-4.0.tar.gz"
  sha256 "5b3f67d7d187e9feb980e1482ba38c1bc424bace5282c6bbe85b4bb98371ef1e"

  bottle do
    sha256 "34a92e5858a02623f53514fed225a4f040551c647e7765a5489cc2918778f512" => :mojave
    sha256 "4cc90703d5be90a2ea09e3eef3113aca2a571c57d3fe98e22cfcc650502654d4" => :high_sierra
    sha256 "b7c6484f5c048b70814ba74560c04dcbcc8834e96d941f7b1efc7eda85b62e8c" => :sierra
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
