class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.6.8/enchant-2.6.8.tar.gz"
  sha256 "f565923062c77f3d58846f0558d21e6d07ca4a488c58812dfdefb35202fac7ae"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "113c9156af9bd4697242e56df663dd9779d810047cc35f47d935a07843065503"
    sha256 arm64_ventura:  "f2f15788ece3d2a36291b4044add67058f103f08e8494ce5bee123e412e06774"
    sha256 arm64_monterey: "7372a47f84170384056e944f48c584fd1e5548a6206687ef83539c8cd8f3ec23"
    sha256 sonoma:         "fc05dc68cc5d2826403cbc49aad1f56e6d2019fbf39f664e865b75f7cc4c19e3"
    sha256 ventura:        "3a5e1d091468f5dccd9bf2a0c2973edf5d9b104df3c5cf60370c05d810bc9974"
    sha256 monterey:       "8f69bb98696eaf9209ada35e38a078cc3355e067e4ca69f3694419054e86f8d5"
    sha256 x86_64_linux:   "697c7c727ec9841c98ed4985dd19c9041d9d519d1838ff91555813640f8dab18"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

  def install
    # mandoc is only available since Ventura, but groff is available for older macOS
    inreplace "src/Makefile.in", "groff ", "mandoc " if !OS.mac? || MacOS.version >= :ventura

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
