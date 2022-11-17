class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v7/nano-7.0.tar.xz"
  sha256 "8dd6eac38b2b8786d82681f0e1afd84f6b75210d17391b6443c437e451552149"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ad928071e65053a144387cacf5d9b499c2f9cb77f99de648892344a6f385b5d2"
    sha256 arm64_monterey: "4f7f8da9d05f8046061dbf6ff153367d69363615fadf9ad243c23a4a6826b5c5"
    sha256 arm64_big_sur:  "94a78963e581d5da80973b3b04548e26fe56632d1321f2b37ae17534a6aa1780"
    sha256 ventura:        "cb3b9b9380dd29a01095ab8442761f770a601fa6075c261bd12ae2c7f2f274a7"
    sha256 monterey:       "5667f6186bded71d8275d8d0fdcf2f241a1b9c0a38eba1ebaa4c974dcc723f07"
    sha256 big_sur:        "86e236e71122e9ca2a0fba8d88dd704bd7f177d589b4a0a953ca38695c6edc1c"
    sha256 catalina:       "f53acb49e04ec7bc16d475fc98bd1032f6820dc2544635e53e369db4dcb73a9a"
    sha256 x86_64_linux:   "f664ee37e9338ea3afda5b65ce40ec61f136d785ad6a6866cd465a4ce203adc9"
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
