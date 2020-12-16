class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.14/enchant-2.2.14.tar.gz"
  sha256 "bf7cc9a410b54c29648c7711dc8f210e7b13768508aaf43cc9c4527d5a9c7a8e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 "f488f13da4f447f7d1d2d4bce0f70673dc7372b106e107961c503353a53a931b" => :big_sur
    sha256 "c9bc06ac40094452e842ba22550d11e101dff6ee8f9076eea9830b417e6609c1" => :catalina
    sha256 "81bbc67b4a2320177e696285759015cd7c263fedfdb1b9cf9b99735c9e2fdaf1" => :mojave
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
