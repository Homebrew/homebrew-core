class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.4/enchant-2.8.4.tar.gz"
  sha256 "e28f98208df5f99320d6a05cd49f83420bf71e69052debe3b343c9bb15c833ed"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "7520f97041dafed8ab04639d896fd59d2c0e82f1dfa1ad11246bed146f1943d7"
    sha256 arm64_sonoma:  "c54a37727ee8bbcc101116ff21ed519caf243905ea7f62e0b6a5c6792dfc371c"
    sha256 arm64_ventura: "4dfc3876af089baf31cf8db3c150ca9bfba81bef3d0f35f33fe37072410c20ff"
    sha256 sonoma:        "b6de80fc2bdc464d4d0f900b77b19a15408c2da0d9343d7829c5500aafa8ffba"
    sha256 ventura:       "59164700fa4ba18f22d2f04ec5759e9de544c50bc013d18d88c104f25a2da71f"
    sha256 arm64_linux:   "7da22b832708e36a1ea7e6d5b25760f3343505fedb0769d607c3aaa3d9fcbc98"
    sha256 x86_64_linux:  "cd586193db002d9c7ba5c10b0d4266b7bf0e60a27d7bd45256c867f7c26e2d7c"
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
