class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.10/enchant-2.2.10.tar.gz"
  sha256 "6a5b34c40647d8524b73a2b0d7104a6375504059ece61ae5ce459500d62cbdc3"
  license "LGPL-2.1"

  bottle do
    sha256 "cf838dedc73428cf7f2f39ae51f72a1534ea27bdc935293d6eb23f59ca8f6caa" => :catalina
    sha256 "64735f6573e7c9d5c079cdd2515dc25101ca12086029fd2ada80f8a7ab85d66f" => :mojave
    sha256 "b7fef83e3582e85c5d3531850adc1c1ed68638e9da016d688824928c39d07b12" => :high_sierra
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
