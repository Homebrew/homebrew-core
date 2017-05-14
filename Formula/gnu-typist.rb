class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftp.gnu.org/gnu/gtypist/gtypist-2.9.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/gtypist/gtypist-2.9.5.tar.xz"
  sha256 "c13af40b12479f8219ffa6c66020618c0ce305ad305590fde02d2c20eb9cf977"
  revision 1

  bottle do
    rebuild 1
    sha256 "6dc14826f6eb2607ef2f0a8875e8f02dc6bb94add086c08aaf60c7eb3f90bc26" => :sierra
    sha256 "7354c4eaf20f8c710b6921fcfa51e77f3959ee2240338a6657fdfff9c59de60e" => :el_capitan
    sha256 "38fbd18da939021fe2ba02f505109a68df569d5e89629b97bfb52366be917dae" => :yosemite
    sha256 "e6242d04086f6519b7d1e8150e03c28e83ade7e34162132010d1dc68abb80420" => :mavericks
    sha256 "14030bc96288152a37b885d74c351be91ba18c03d48430ad95b9294d46ff0544" => :mountain_lion
  end

  depends_on "gettext"

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/42c4b96/gnu-typist/2.9.5.patch"
    sha256 "a408ecb8be3ffdc184fe1fa94c8c2a452f72b181ce9be4f72557c992508474db"
  end

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    session = fork do
      exec bin/"gtypist", "-t", "-q", "-l", "DEMO_0", share/"gtypist/demo.typ"
    end
    sleep 2
    Process.kill("TERM", session)
  end
end
