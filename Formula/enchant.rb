class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.15/enchant-2.2.15.tar.gz"
  sha256 "3b0f2215578115f28e2a6aa549b35128600394304bd79d6f28b0d3b3d6f46c03"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 "fa2be4ac2134abd0e26253fec654924b0331abe62588a48840e3a467ec4c20c2" => :big_sur
    sha256 "a18ef73a8b2164aa221d4d9a35e5e2986b8beea6005401ac4ae2f940f1fc9300" => :arm64_big_sur
    sha256 "822040f225a771c940f4595a3b7e7c592c6a794828bbc34bce8b8f3143c70443" => :catalina
    sha256 "cb7f88089f5fb746127ad384c7f3cd813f16b1ff9b7b263872bc75b1a9293916" => :mojave
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
