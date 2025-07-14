class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.10/enchant-2.8.10.tar.gz"
  sha256 "6db791265ace652c63a6d24f376f4c562b742284d70d3ccb9e1ce8be45b288c9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "dc1c11cc5660743587d0f08e6f58705d22c15f4f196e7eea7e9321c1d09240f9"
    sha256 arm64_sonoma:  "11066d69773226674fcc8a3b4554c7eaaa50749e2b2e2707c02d1dbec2421106"
    sha256 arm64_ventura: "de0cb85d1334ec3ea00449ca6755a38fdb41476c76e44a0430c667ca3f790439"
    sha256 sonoma:        "e79dfdcc955608aeed8ba1c0ddbb501dcf6f3d08d1c6172f0dbd8415f6d05ac6"
    sha256 ventura:       "88ec4516a8267e27ac4625433a8b8b583f88e4de59b08e1078bb5459d8c7ab73"
    sha256 arm64_linux:   "e0794aa507a518a2e99ea785f895a9278f81af50d53be53c56cb149e2145314b"
    sha256 x86_64_linux:  "9a73e01a5e2865fbaccca0387b38a4de2ff87a7fe615629c91def193f4edeae2"
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
