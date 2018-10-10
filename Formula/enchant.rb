class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz"
  sha256 "abd8e915675cff54c0d4da5029d95c528362266557c61c7149d53fa069b8076d"

  bottle do
    sha256 "4760ca13f888ce5cde5e6d70fd50bf694ab8a2801ad4f613ee4680816fa20fd4" => :mojave
    sha256 "7df6114c8fce8c93e1c7cd981ea9b5e7033eca9d5706341a8eef8fbc53f57602" => :high_sierra
    sha256 "5a3a649fb73ac04534056088294909e044c4665c99943020f668e1ca7ed99f3c" => :sierra
    sha256 "4240a9afdab529f1349963fd7d0e90725365fcd8fa27a937d5fc115abad50a65" => :el_capitan
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
