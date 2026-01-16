class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.14/enchant-2.8.14.tar.gz"
  sha256 "d04588769399ff7140fa214b9731e6fc6eda9bb2e75df9f67263717710bb4c4b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "ed4eecf1d5071c4fbd585402771722039222ec348a0be78414a3ef865ac13b6a"
    sha256 arm64_sequoia: "c131e6f34289fdf302eb605e78dffbc1d48b634b805e2604f0996ed9e9f9d0b4"
    sha256 arm64_sonoma:  "ec742e78953156cfe2c935f6660d4933c20049a28d9d2cf38a3988205d6bcde5"
    sha256 sonoma:        "d20a63f4f958f84f45be9cc44d9505f4ec3d77996d780d4e766bfde62a741b4c"
    sha256 arm64_linux:   "5f83181294b7094577ecf1d2cec0f7d1a933a6dbef45079750bfc74fcb608fdf"
    sha256 x86_64_linux:  "20075ed0338b4eea83bc0d8a34551124e5ae6123d31d26d47ceb1ae538c01863"
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
