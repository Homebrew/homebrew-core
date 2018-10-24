class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz"
  sha256 "abd8e915675cff54c0d4da5029d95c528362266557c61c7149d53fa069b8076d"

  bottle do
    rebuild 1
    sha256 "558ae345cf128bf0eac582e1de427f40c0a8ab55a8b3ad3fa8d184c3c2f2eae6" => :mojave
    sha256 "1e0a55ea0aa6b7c3e600e0fdff5dea8e58f48f5a758f5923f35a75bbd11606bb" => :high_sierra
    sha256 "f58d3db9c100f56bb99bdc717975dcb8563d5c5fbfb07135834e49fa3cf43a8a" => :sierra
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
