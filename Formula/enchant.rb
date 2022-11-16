class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.3.3/enchant-2.3.3.tar.gz"
  sha256 "3da12103f11cf49c3cf2fd2ce3017575c5321a489e5b9bfa81dd91ec413f3891"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "2419b0b149449885edc9031ae6be9576e7b1282d85278b3b5c31dee0474de081"
    sha256 arm64_monterey: "a108e65f994b1f4d783e337d3d91b1cf97232286ff12e171e40b89e81f8812f0"
    sha256 arm64_big_sur:  "76226e20f61ffdc8ba8e5adde919251bbf720d2011c66e74ab2858211fb3d8dc"
    sha256 ventura:        "01ff24fc7b1905e91ff39c325d40acd1db1f87203893ae2cc25bfb3c6b8ff6b7"
    sha256 monterey:       "3c3d3295fda5cbe97b11ded4c8c7f21754fba625626c6de87e659744afb268a6"
    sha256 big_sur:        "a62e218d184f399cd6404043099363b32ace55760cb4ea8d249e017e281dab33"
    sha256 catalina:       "35342a7cd9748ec02b714b042f6624320a8c8159cc25880684416cf3927b532d"
    sha256 x86_64_linux:   "2d43c2614be362e7a7f34cdb4ddf655c28a13fd0387756110a9d2c8dbc1eea96"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

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
