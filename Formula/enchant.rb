class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.4/enchant-2.2.4.tar.gz"
  sha256 "f5d6b689d23c0d488671f34b02d07b84e408544b2f9f6e74fb7221982b1ecadc"

  bottle do
    sha256 "9df8ae585764f4ff8ee82cc8917d9e5cb6fc462f1dd4cb693ecb1dc34cf0e750" => :mojave
    sha256 "7bff28ac86322edb0b27a444e6e5be5a5b20d9577303136ab7a15a7a78e1411b" => :high_sierra
    sha256 "1c839321e57c5929989685e6a2c98a169485836c5652a3e6ae48f93d8251d3f9" => :sierra
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
