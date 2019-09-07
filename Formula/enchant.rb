class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.6/enchant-2.2.6.tar.gz"
  sha256 "8048c5bd26190b21279745cfecd05808c635bc14912e630340cd44a49b87d46d"

  bottle do
    sha256 "0e51ff0b863bf6722d1e9bc8cf16fc2c3dec2217954eade9731664f26b25a41d" => :mojave
    sha256 "9c525dafb12a2563583d59fefd9e41789656af581bd7540186858b5d7768383b" => :high_sierra
    sha256 "44324d4b2a59ed2de79b944c663c0c87e7f583bd67f3916da19b9f67b5f900e5" => :sierra
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
