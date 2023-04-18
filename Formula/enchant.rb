class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.3.4/enchant-2.3.4.tar.gz"
  sha256 "1f7e26744db1c9a0fea61d2169f4e5c1ce435cf8c2731c37e3e4054119e994a0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "33131c5637900697bb08e71fda95d1fd3a1bfb789d55e196a91f52fcb4a4e502"
    sha256 arm64_monterey: "82a4a5255b076b403c57a10ff92f7c8c98e0e2169008862e9b54b861803e242d"
    sha256 arm64_big_sur:  "06e1c490c5e09ad448528b5ee696b4a00ff61e7f74dcc5a072746bb36b5b1f91"
    sha256 ventura:        "4a0f4ce54fb5abf089e9a5ce5313842d7c9295937f3635a427313d3193a3aff2"
    sha256 monterey:       "0b4ef506a076d54b1586ec6d7721b6d62baba2f1ecde625f137b44ee6b1c6d39"
    sha256 big_sur:        "c6b4e2c692d70bf8990324776948abf593c91a82df6feb03673cb2697a4ea34d"
    sha256 x86_64_linux:   "8985c241f2066c2f6d4740ab73c32bc9b4c82ac6dc0e5900c01ceb6a69c71eae"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

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

    # Explicitly set locale so that the correct dictionary can be found
    ENV["LANG"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
