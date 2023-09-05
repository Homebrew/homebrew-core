class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftp.gnu.org/gnu/gtypist/gtypist-2.9.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/gtypist/gtypist-2.9.5.tar.xz"
  sha256 "c13af40b12479f8219ffa6c66020618c0ce305ad305590fde02d2c20eb9cf977"
  revision 2

  bottle do
    sha256 arm64_ventura:  "1680a0da992d03808e31f28c258317c5fdeec3b69c0d0347da09b53bc911c220"
    sha256 arm64_monterey: "11053d3574c7c569cd3bdddd8e48e0609af0abdc0638346f810168570411f16d"
    sha256 arm64_big_sur:  "b241409e921daccc7d82bfd1641ba1b6fd43966d19458fc580d4245641306fe2"
    sha256 ventura:        "c9d69f252c6f74fb9d82c7ba6c79f37b9e4180a8348c2ad7b518eabb6dbaa153"
    sha256 monterey:       "100c51f8f078f96c5e4307ed3f7d2aced6ae5975ae91df6aa208932211113d5e"
    sha256 big_sur:        "74506e983cf7d74abcd8cfa4007d8429cdae7283a1b3cd3a3f0272d4380df024"
    sha256 catalina:       "2a824f3fad3871cbf43f15009c23563aa03872597f22e823f9e2551d35fe1e26"
    sha256 mojave:         "9f0fcdd42b9a041408b132882778db2eb479749a7169b82f2caf1f4fd486b599"
    sha256 high_sierra:    "72503afd4efafe7a8485ea22332819937008263976a6f5f5b42818565d59edbf"
    sha256 sierra:         "d32708d6e8a640101ac618ceac23be6b9d1a6a4caa127c5fd12a44b4e57c09e9"
    sha256 x86_64_linux:   "46bb2345984a78a4ff0bb6b91d3417311c54105ff5bc96e851f74919d78f86db"
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
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

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
