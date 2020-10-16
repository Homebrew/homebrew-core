class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.12/enchant-2.2.12.tar.gz"
  sha256 "6b9bc58ae714ee7f5335ade966f4ac5718d5339e280cc9e1cca9ab278c06227e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 "addeb2c86e547313a7b3723fe4c1fb365e0ebf30679ebdf524b7bf6d6004171d" => :catalina
    sha256 "7c68161deff5d5e822290bf16769ab90a99778cad21147d4405f2ed6091b4e88" => :mojave
    sha256 "b720b5ab7073842a2a7dcdb70a4c7f7971d92d91b45f67e447ac0b323d6cd2a3" => :high_sierra
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
