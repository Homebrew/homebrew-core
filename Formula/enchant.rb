class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.6/enchant-2.2.6.tar.gz"
  sha256 "8048c5bd26190b21279745cfecd05808c635bc14912e630340cd44a49b87d46d"

  bottle do
    sha256 "8b57e30f33ffebf6269fe92df92ab9210d62bacb074beae936e1c7696a380be1" => :mojave
    sha256 "67b8e1072ce0ee854dfa020ce964dce41dad1b5f5c3bcf6371aee14250d4e77f" => :high_sierra
    sha256 "a256ac7e92352ed9eb6cb8669f6032e314847a89127d6ffd560b90f49d7b8242" => :sierra
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
