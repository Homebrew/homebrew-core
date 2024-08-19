class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.8.2/enchant-2.8.2.tar.gz"
  sha256 "8f19535adb5577b83b00e02f330fe9b9eb40dd21f19e2899636fc4d3a7696375"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "4327d3746697c8a0935580936c827a2ded1dd92d91bc2655d4ba9ee643ede046"
    sha256 arm64_ventura:  "912e6067764e4402e6c718a909cca6b1fe1a380902d5e536cae1fe05d6cad047"
    sha256 arm64_monterey: "e617eed7551db798a3b0fbcf8da0f8fbb51c72a351952309a5ba5a70b189dc12"
    sha256 sonoma:         "7c53b37a59b7be9b065d5a45e75a4b605fd671c6e4495abd96b3e689b8624aba"
    sha256 ventura:        "f6ea7979e2ef7d12132449e590ef560b6c1d2a068da3bbe42206051d00f08eca"
    sha256 monterey:       "10cdfb36ac05c8f07d43cf0687425f3677a03cddcd0ab39c42065aad1e7d0f22"
    sha256 x86_64_linux:   "d0aab4334f7a0feb7d168863bb81a4800982aacd709bee3b96146328b0a9f097"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

  on_macos do
    depends_on "gettext"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    # mandoc is only available since Ventura, but groff is available for older macOS
    inreplace "src/Makefile.in", "groff ", "mandoc " if !OS.mac? || MacOS.version >= :ventura

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"
    ln_s "enchant-2.pc", lib/"pkgconfig/enchant.pc"
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text

    # Explicitly set locale so that the correct dictionary can be found
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
