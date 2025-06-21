class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.10/enchant-2.8.10.tar.gz"
  sha256 "6db791265ace652c63a6d24f376f4c562b742284d70d3ccb9e1ce8be45b288c9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "0ee4cdb901464094d171471c561844363cb394caa9039752ef69dda4131da8b0"
    sha256 arm64_sonoma:  "7a09c1472767fbd434189c14dad79552b55aace339cc9508397d20cdb653bff7"
    sha256 arm64_ventura: "7ca524fd6961a6707a19b85cba4d959c0160e9b0798e3433d834de8ee6e70881"
    sha256 sonoma:        "66664f0efb7caa91d559c9ba9da422240b065d6ab8efbbcdaf01e12790924e0d"
    sha256 ventura:       "c3e77e4dba9ad1532fe801f5bebe30163cd727625f8cc3475c027c60a05c0269"
    sha256 arm64_linux:   "318841bc2aa4d39078b12fbd553dd0021c6a31d480fde41a90f07463aaec382b"
    sha256 x86_64_linux:  "97365f0897d8adb6ea65746579e7a1271d75943ef85dfa6753e60f1565b6b88c"
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
