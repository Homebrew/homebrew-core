class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.6.4/enchant-2.6.4.tar.gz"
  sha256 "833b4d5600dbe9ac867e543aac6a7a40ad145351495ca41223d4499d3ddbbd2c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "31c44ae8dbd71bd11473ab3fe00752571b8f71c98aaa64a2634b96b9944bb64c"
    sha256 arm64_ventura:  "6604d55a5579bfd9d7fc5fc4f39e179c0c7ec96fd77ed51e6e0edd62065c134b"
    sha256 arm64_monterey: "4cd0de1ab9692ca4ec9aac9ab20da3cb0ce40521a0b17eb9a7ce7003068da5ba"
    sha256 sonoma:         "3d73788eedaddb7f29eb22e5f3e4ff8a672750a0ae7bada59bc5b035681d8bc8"
    sha256 ventura:        "8cc9e53610ecd958886ea6bca5da55be57fb4f5c77cc1204a87c858232b5503a"
    sha256 monterey:       "b24767eaec0eba782e7d9ab9ff5bfc97346907e2f42644fa6334dacab02be598"
    sha256 x86_64_linux:   "76d546cf1890a8c358ee73dcf660d9b44747e6ab2dd42323ab165ad689ef5929"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

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

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
