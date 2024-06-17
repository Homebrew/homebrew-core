class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.8.1/enchant-2.8.1.tar.gz"
  sha256 "ff79de470b8eb16f53849dc49f2bce8ca4eb7decabfc1349716fe12616e52f4e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "d20879e9c4f45cfa696d4038c3d46e975fafa20f74458c27eea9eab54107966f"
    sha256 arm64_ventura:  "a81e8c7790174998dfa8f524757714d960529214985ade7d09d6e7109746bbaa"
    sha256 arm64_monterey: "ea8c2446d044422788c8da29c8deca5bac1fd9af188448da142e214b4c06a97f"
    sha256 sonoma:         "0962732fc652030fe2fc85b6eef4ccfa5472379d72c526d32d781d896e1ba734"
    sha256 ventura:        "d3ab90d97d720399e3f7b241b3a1e3471222ee9a7b9e23b3b70ef5e840c41333"
    sha256 monterey:       "6a737a7067a3032031d8a59ef70e5f043eebf59586c6797a66a5689744cfe86d"
    sha256 x86_64_linux:   "b90f84daed3ce1a5e1f68afa87d30bdd9fd4ad02097ef6dc6a0c54c15bddcbb7"
  end

  depends_on "pkg-config" => :build
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
