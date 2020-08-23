class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.9/enchant-2.2.9.tar.gz"
  sha256 "b29a3d2273f5edcbdbbb565e94bfd8ea3f9526886fcb6327b4b0f72f0d722f3c"
  license "LGPL-2.1"

  bottle do
    sha256 "d469967da67083b5cc8bc487abecda421ee2e325b96e39fde1c7e8679c58b0c7" => :catalina
    sha256 "ec8877a36d41989ae3bd3c532908017c4f4b959956777c6098bcd5e305d22b51" => :mojave
    sha256 "b2fb985de774158cad73461be089bf6734bc096f0060c7b6cb2eed2016ed273b" => :high_sierra
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
