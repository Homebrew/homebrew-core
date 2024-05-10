class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.7.3/enchant-2.7.3.tar.gz"
  sha256 "fe6ad4cbe8c71b9384ffdef962be52d4d2bd5ebfb6351435bb390543d4f78b1e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "a3379030d191b09ee2be1d48ab9442c5520d67379a16f1d4877690c7bf038b10"
    sha256 arm64_ventura:  "de4743d60a4fdc142c1e2b777edf2116e9dd35f123a74e9b2ed51bb463eb83a3"
    sha256 arm64_monterey: "84c4caea703ac25694264b8831cc683687e74d209d41d01a7c6f59012f12485c"
    sha256 sonoma:         "c0731ff8693cb78abdfbab3d96dbbc82495c065e44cb6c3ac03e11dbdabb35b4"
    sha256 ventura:        "2379943777e66e63bf3dbf53dcd2f54658ff114dae8e231d6f83c1d7cbf1beb8"
    sha256 monterey:       "ec66f38b40c09c54d91d95eb6c017cb56b9e48462925cd80366240eed04597f9"
    sha256 x86_64_linux:   "9e4d3561eefe47808a9093a86baffa79a7ee22384c6b8e52c1b13c2eeeb0d4d2"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

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
