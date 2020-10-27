class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.12/enchant-2.2.12.tar.gz"
  sha256 "6b9bc58ae714ee7f5335ade966f4ac5718d5339e280cc9e1cca9ab278c06227e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 "0c40244d0bd199935fe55a80c18c71e818efc862d73dfe7a1d29cf8f3b14e0c6" => :catalina
    sha256 "fc0a2c0830b43251eaf154f3d20aacb9302f31d3e5f917fc36e56fd5b1e01c8a" => :mojave
    sha256 "1153c881952bf1fca303296419c4b91cbe078eb4898618c6cacf36b7090778ed" => :high_sierra
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
