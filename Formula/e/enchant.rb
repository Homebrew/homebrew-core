class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.21/enchant-2.8.21.tar.gz"
  sha256 "dd2a762697c463148a8f59867089a5ebf2dd1449d869f93764b76c12bcf8acc0"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "711d4da9d53879ffb4d7209d0b1fcf2cacb8bdb2188c1747418f54493b9e2261"
    sha256 arm64_sequoia: "4143cacbcb438b7f102d5475502939acb61cd6c32dfd284f03eeee52c7b979da"
    sha256 arm64_sonoma:  "bb0d18968e03f6c777d4d71750c4835b511d5c74814919513bcecba4a37ec6da"
    sha256 arm64_linux:   "3605e95cb693d2ac0a1668a80f2352db7535dc2d451ff8c033bd3f9015c87664"
    sha256 x86_64_linux:  "9c520607593d537244cc3ff84475974229ceb430de8d5ad6f6decbbfc80ece56"
  end

  depends_on "pkgconf" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

  on_macos do
    depends_on "gettext"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

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
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
