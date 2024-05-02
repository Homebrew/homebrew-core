class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.7.2/enchant-2.7.2.tar.gz"
  sha256 "7cc3400a6657974a740b6e3c2568e2935c70e5302f07fadb2095366b75ecad6f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "1e9fb4d5067ba80fd10c659b1662593c9cfe053e13e6eb0ab3e12b8714a62ff6"
    sha256 arm64_ventura:  "c81d3ff0dd4b1d910e6c19458522de78a76f344ea8cdc7d99c9ebc60ff5ad629"
    sha256 arm64_monterey: "734dd5f68de39965d596157097c40c64f99937e761dd068be05eea500bba16ab"
    sha256 sonoma:         "020b4b30f497d56b79612c0911ac425033357e8be9f7b9771a601f8be2c62888"
    sha256 ventura:        "29a844736c0f3acbd24df25b4e53d8dde673cd88938e33de2dd6476e0e871931"
    sha256 monterey:       "30e0fae303c4194ee42525df9df5f67d9dcb1c362d87143425dbf0c0c382d052"
    sha256 x86_64_linux:   "fcc6f3631aafe243dcc3f8e109c6f9209dac3aad9585d4ebb61aa05a444549f9"
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
