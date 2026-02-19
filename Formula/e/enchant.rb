class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.15/enchant-2.8.15.tar.gz"
  sha256 "d3fd9e4170bfb5110b0bda577fe764a38fb606b3c25d2f0c3840234521ff1252"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "b425927ed1f2cb4137b768acee1f4d8cb8bdc96f91af90edb17f6fd8c72ab86a"
    sha256 arm64_sequoia: "1d88a945284e60b55266cc421446bdd1edb48fae2665d5b0ab3abe75194e2f1d"
    sha256 arm64_sonoma:  "1927d4b59d0ad535e927fc78e09997e1fe94142a7e2a24c17cb4b5e712c156ea"
    sha256 sonoma:        "8103b1c3162c60927d99e64e8dab6f019434e784bb711230acad5248c5850152"
    sha256 arm64_linux:   "51932cee025f0838333ab3f3e27211b638fe464d17d8348160deeaf5d3afce72"
    sha256 x86_64_linux:  "60fa6904781a17dcb6344df28d80fe643d44257ac8868deb11e2da21130ff3fc"
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
