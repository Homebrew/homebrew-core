class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://nano-editor.org/dist/v3/nano-3.1.tar.gz"
  sha256 "cc99372b6e3f38a86617143cbf5987f33641f541334070146dc2648aba1fa42f"

  bottle do
    sha256 "de5c17c809bd78176eae463f45859dcedcec40a3fdca17986ced4987657e84c9" => :mojave
    sha256 "dfa52118c97bc70209025d89c9b17845fa6e2cf13f9debd9d420c7867390fa96" => :high_sierra
    sha256 "c143cfe93af581922639de54cf871d23f80f879e0b18e08ce6bf0c7b88d59955" => :sierra
    sha256 "158bac14701d00daba1cdabe70bc6dc8352faca0f129565804a603e44a362b44" => :el_capitan
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
