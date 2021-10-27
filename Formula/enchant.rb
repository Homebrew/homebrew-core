class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.3.1/enchant-2.3.1.tar.gz"
  sha256 "7b4b1afcf2cd8bfa691deea6188404d337f23174bbc39b9c2add2bf340736e9c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "2cf6840a590610ce93c66d0cfc9fe2956fde086768e05695dc4d74917d16c4f2"
    sha256 arm64_big_sur:  "eb03db081057d7da6ca3b0f6b4e2b1c3b1cdbda2db9d8b6ab8a4af1cdb8a5324"
    sha256 monterey:       "e2237aec8b2245a2c63c34a39ea78dffe792dd732380d982cd97f67c859aebbd"
    sha256 big_sur:        "dc7c90e234d16a8a5d120aed18d8128488315e1dde6a2fbfa338da1ae90a618a"
    sha256 catalina:       "e220a1df14ea2f3532073f35dab0ee2c061fa002660ca85f744d6cc5d068bfe3"
    sha256 mojave:         "b5879a947bcce1d1162768bea9027fff9d74fad12b45a507306a0c26809c8f20"
    sha256 x86_64_linux:   "bf93e5908e1bc27d2b7414a0f0d8bab29f7bbcf3193286d021b7146e4c6c6ef4"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  def install
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

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
