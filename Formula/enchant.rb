class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.3.0/enchant-2.3.0.tar.gz"
  sha256 "df68063b6c13b245fa7246b0e098a03e74f7a91c6d8947bc5c4f42ce55e2e41d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "a18ef73a8b2164aa221d4d9a35e5e2986b8beea6005401ac4ae2f940f1fc9300"
    sha256 big_sur:       "fa2be4ac2134abd0e26253fec654924b0331abe62588a48840e3a467ec4c20c2"
    sha256 catalina:      "822040f225a771c940f4595a3b7e7c592c6a794828bbc34bce8b8f3143c70443"
    sha256 mojave:        "cb7f88089f5fb746127ad384c7f3cd813f16b1ff9b7b263872bc75b1a9293916"
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
