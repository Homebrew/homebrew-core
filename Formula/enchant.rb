class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.7/enchant-2.2.7.tar.gz"
  sha256 "1b22976135812b35cb5b8d21a53ad11d5e7c1426c93f51e7a314a2a42cab3a09"

  bottle do
    sha256 "d5eedc2985d47ad2c68fc02920ce159ffed812dbe21a0798a0c19b9c764b73e0" => :catalina
    sha256 "31b8df7f3a7c9000a9172a08e95563e4c0aa5eff9166d5908637adea3f3853c4" => :mojave
    sha256 "5175504ba38adc84dc8b0eb756270de9509c0702aca2eafc399a237bba67cb0b" => :high_sierra
    sha256 "cbdd497839d06d13c0457ae4ce827bcdbc85e976902598b39fae14821cc1a3b9" => :sierra
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
