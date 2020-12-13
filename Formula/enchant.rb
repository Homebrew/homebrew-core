class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.14/enchant-2.2.14.tar.gz"
  sha256 "bf7cc9a410b54c29648c7711dc8f210e7b13768508aaf43cc9c4527d5a9c7a8e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 "cbae9c0ee4b2c3196200e273df4a2f1cc25995d4e5cba17387ae7cd82e7ee459" => :big_sur
    sha256 "54ab4b4e7d6c8f8c222ff7abffe56ca8c2f4fbba466beed8284d45823bef8c5e" => :catalina
    sha256 "6fe8c922c85aeeb18a229190db56fbae1504698d3839cf9ed7fcdb5e4d44772a" => :mojave
    sha256 "3dcbc8f4fa237626aaba1caff0448af6e40869491b62acec79e9b572daa273d4" => :high_sierra
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
