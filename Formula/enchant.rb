class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.4/enchant-2.2.4.tar.gz"
  sha256 "f5d6b689d23c0d488671f34b02d07b84e408544b2f9f6e74fb7221982b1ecadc"

  bottle do
    sha256 "7fbdba60b779300ac514dd72ff45d70ae31614e9e8b745bbf7991b67d2046fab" => :mojave
    sha256 "27754a73f3687c807dd3279347cd3c7087ae246b2854a0ec98a7f2106485a33f" => :high_sierra
    sha256 "5720e90a3e0e8d3ec640342f845949a54cc040bd105bc2d6412c4a9e35004016" => :sierra
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
    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
