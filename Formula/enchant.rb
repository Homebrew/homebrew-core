class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.3.2/enchant-2.3.2.tar.gz"
  sha256 "ce9ba47fd4d34031bd69445598a698a6611602b2b0e91d705e91a6f5099ead6e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "869c69a9a1b571303841941f6008f4f0d2cbff36f2c64b80c63174c614019c0e"
    sha256 arm64_big_sur:  "f60f85a4b58d07f9dfc54105502a1c97dc47070e792075513c146ec823189dd9"
    sha256 monterey:       "c67c8156619b551a9dc380750b9d8ec7e54b957baa0a7c38fb932aa9b5b6bc97"
    sha256 big_sur:        "86ea290d09f8a7cb0818cf3783908b6770397fc98a2f3362d75d2c52bb6964f2"
    sha256 catalina:       "711c56ae3eea07b51b939dabdf5776c98d562732ef2e58e48c8461b89f0c0d0f"
    sha256 x86_64_linux:   "51c64a8487d3db1bad54d8bbe4e2ae44fd28dabcf2593b17d37e03243de1906e"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"
    if OS.mac?
      # Use AppleSpell for all languages by default
      system "echo *:AppleSpell > #{share}/enchant/enchant.ordering"
    end
    ln_s "enchant-2.pc", lib/"pkgconfig/enchant.pc"
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text

    # Explicitly set locale so that the correct dictionary can be found
    ENV["LANG"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
