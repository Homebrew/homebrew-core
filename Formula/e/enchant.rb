class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.19/enchant-2.8.19.tar.gz"
  sha256 "c8d70991d544ee39274b96bd01d2858a009fe732ff43f2aaf605fd61ecd06f60"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7fcefb9245bb9bce42441e89b69747c7b74974a4e16d222909cd2b81d0ccc5f9"
    sha256 arm64_sequoia: "fc26cd865f6f28e3305dc0fcab51fd803cc3cae53f321b499a05b8c3f73e6f1e"
    sha256 arm64_sonoma:  "c6d162f6d320b3d868e22703d739b6a14e6b2744057a58ebddced0bceb9d53e6"
    sha256 sonoma:        "4479b73669963a0e7fcea60b33a0306618185b30f3bc903f7e74852913fd4a77"
    sha256 arm64_linux:   "dad8f77271bf16c3b2e12cece5db04f2fdc1182b3b2335e15ea7853e10e1b9f1"
    sha256 x86_64_linux:  "ec963b8441c8604ed82ae63cb531cb0fa9b022f0a06f742736cb0970a27bed44"
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
