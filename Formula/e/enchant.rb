class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.12/enchant-2.8.12.tar.gz"
  sha256 "20e5fab2ca0f95ba9d1ef5052fe5b028e3e1d66d4cdea6b9adfcbd3e524c2a09"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "a5e8d8bd49c046eff1b69f60fdceb8850c3ada1caffa6c1f50ad03366178ae8d"
    sha256 arm64_sequoia: "bb220c90e4f079d85f882ae8fab9e69fd2bbcb1e782a223da88655123ff6f83b"
    sha256 arm64_sonoma:  "f5652e7e3fad548a1243f1aaa60b53c61288611f10d78b68520350cf6a5f72f5"
    sha256 arm64_ventura: "15c468f5a93b2af19773e987d03d7f85f532d7bd73b1860be8c4c356bbab2604"
    sha256 sonoma:        "0a3aa608e5d3875f113129c9469c655cb6effc2699143593f6cc62d214fffc27"
    sha256 ventura:       "58a5ddf739b3000c50e27453684ac320da080b2ee0dc21cd803fdd4c0cd74cea"
    sha256 arm64_linux:   "7a74f8e77fb9d3d5d59f334fd01b68d43a7a7ad63b2e4259fc72205acf4f1ce2"
    sha256 x86_64_linux:  "052362b93ff0d370b961bb39aff6da875260d1eee9c8281f3ce581e16a051c79"
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
