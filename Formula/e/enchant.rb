class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.6.1/enchant-2.6.1.tar.gz"
  sha256 "f24e12469137ae1d03140bb9032a47a5947c36f4d1e2f12b929061005eb15279"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "87cc14b7ea2f853a38808aef390503316d0ef66407d39665f01297e04dac837f"
    sha256 arm64_ventura:  "823bbb3f99b42ad0166ad71fc633e618f1924fbb43d1649518c94f76495d97e4"
    sha256 arm64_monterey: "2a0522e912ccfaf35d55e5dc78bbdd5de47f66338cc7f3c216f0c1b12ac61ed2"
    sha256 arm64_big_sur:  "01a03e1177d717c4f72ed163a5e6ddf92840e6362ac9c55a7c6ab661eb3264de"
    sha256 sonoma:         "886265261a046ce8c2382e21df1faf78558d3f5d9de53114d0dbcdaa5125ca8c"
    sha256 ventura:        "bd7d7322789a19456eedc5a1faa312631bfb282e35711a499f3f00d235560d3e"
    sha256 monterey:       "45ceea44ccb9cc1a2d85c437ca809b872abd14259ac46984affc7e2ea8df28a7"
    sha256 big_sur:        "3d070c8586b3eaad737ceff6bef6dafcb3cac3ced5cbcf943936a1127bb3a593"
    sha256 x86_64_linux:   "16077f5281c7eb511e359cc0cbb1d7c1c976eb345b4c4354e27066b7c39499f2"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
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
