class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://github.com/rrthomas/enchant/releases/download/v2.8.19/enchant-2.8.19.tar.gz"
  sha256 "8e7f6cb0c3b79be3146eb3ab93650484adbc59dae5f2c1958fde557080ba678c"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "5ec902e43601663826459458de83b2163c4921d2fed40201fd0a0d01604801eb"
    sha256 arm64_sequoia: "55be44a0b1487607c99ee9cf617932e001ad59ec12a7abce004a2636b6b47f58"
    sha256 arm64_sonoma:  "96fef54beeb48e473300b8a480a373106d7723eb9abf786c8c698f7f78d97aa2"
    sha256 sonoma:        "4cba9968d795a6b167db50d408bef8e3d0e5e0f82001d0ded07beef41631c557"
    sha256 arm64_linux:   "e9836769f06b8a068c207e15a58ae776c302eefc51b00f0204e48d98cdac7ea2"
    sha256 x86_64_linux:  "c386827efe68b7c4b4b3de3baf1aa6a9e014195160d9b4894bee371ce4557355"
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
