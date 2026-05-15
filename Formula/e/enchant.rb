class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.16/enchant-2.8.16.tar.gz"
  sha256 "d73162b5eff401a6397e1215e2b103bcef83f921c396c7f6b1394d2450d124e2"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "ecfdae6a039cce109bdf997ef6d67932330c4313452f293117d84bcce3643fee"
    sha256 arm64_sequoia: "90d2261b3f615160ca505eb37f1f700dfcd9cec614038e2fc0d8deab1a5a3acc"
    sha256 arm64_sonoma:  "853730a9fa0e8bb20c172ff5b5e44037ae50a8e5513b298de387c8f62bf82acc"
    sha256 sonoma:        "1c6f2c54d34d07cf37ecb5405929f9bad7c16a810ab7c981a14f3473b996b4dd"
    sha256 arm64_linux:   "078e0ae36b40f43db4cef0b725aa400ce047953c3398dd36a6afac37d2ee3cab"
    sha256 x86_64_linux:  "1fef602fea4db3762eec3eddb58850e0ba993aab63c6c4082bce04fb93a4d73f"
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
