class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v6/nano-6.3.tar.xz"
  sha256 "eb532da4985672730b500f685dbaab885a466d08fbbf7415832b95805e6f8687"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ab97d087e84b4f5a22a8416ba12c5083c5e380f9cb1f7e9ad813b35624e4d3ad"
    sha256 arm64_big_sur:  "814ed07b376243bf32321ae76a52d11f8ea1f27cf9056ca15074294f33cbdc36"
    sha256 monterey:       "5da2f0bcd41657f106452ce647657b613b7114b9de5f2e9d4f86051141a78cb4"
    sha256 big_sur:        "de4cb72aebe0439aa98e5c7be546c858f1683dfe0835b326aa9d609d25876b66"
    sha256 catalina:       "58a684e38a61c6e9d62d7f855e73516e71157fe30a7670b55a5a8063d572a0c0"
    sha256 x86_64_linux:   "ef8b3532aed5182e7065acf93376a98762960285116b7b54d34e6c9b84c828a4"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
  end

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
