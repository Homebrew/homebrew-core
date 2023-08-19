class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.5.0/enchant-2.5.0.tar.gz"
  sha256 "149e224cdd2ca825d874639578b6246e07f37d5b8f3970658a377a1ef46f2e15"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "2e9fe5662f8e9ce44c9ef6be25ce64e610fb04236109bba76949bbef8bab0068"
    sha256 arm64_monterey: "f69d850f1af6b3648575371ae70ba84615bee286cf6945b832ac802bf2603e1b"
    sha256 arm64_big_sur:  "5ed052515f5cc15592f15d046a62c7b81afc0932d1f9e26bd9c94522da40b6d5"
    sha256 ventura:        "9433fe872bc8828b2096ca2495b38a0e0cbe44adcb6bf78df974aa0c4e62653c"
    sha256 monterey:       "c238fd27b94c9fc8bf33ccfe8135ad5233415e57aeda8a69f5a54c82c76b303c"
    sha256 big_sur:        "1f7fa1ebe263d96f38d2160bca113cbe81d0eac96769556a923087645059e090"
    sha256 x86_64_linux:   "4d8d642d8b3c06ef7e8ae8fa999f3f57b036f8703ab15b9be7345a8b6e98ef27"
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
