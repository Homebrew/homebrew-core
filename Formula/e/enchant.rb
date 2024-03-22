class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.6.8/enchant-2.6.8.tar.gz"
  sha256 "f565923062c77f3d58846f0558d21e6d07ca4a488c58812dfdefb35202fac7ae"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "dfd127217969c46b7eb19ab38588a71da8ffb1236938b5c771a9034f0e6238e3"
    sha256 arm64_ventura:  "960c124b38ee1f56c728857017c4ee7043abd031fc626ae04085dc188c381428"
    sha256 arm64_monterey: "74c6dea4be58280eae1bb606e510342216497421e91ffe5ae4155f69c82e4ef4"
    sha256 sonoma:         "fe0aea6a3e1f47b6d3e3b85f9d4235b90fb42e3a142fd39dd78a99c7517b5969"
    sha256 ventura:        "f1aea653f5422bc2f97b9b5937d83b99b4fda602d1f0f615774a799ce6c26bba"
    sha256 monterey:       "2498dcfd414cf96d6f307c94812ee28b8845552b383fee9024e5f4d53ac9b565"
    sha256 x86_64_linux:   "dfff5657be3995016e2791799a3b40b80745b892ceeac230f94ee5cc79f74c92"
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
