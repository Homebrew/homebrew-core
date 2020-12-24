class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.29.tar.bz2"
  sha256 "a980e35f85c9661fe0d98c670f9d6be56000da2bbc8b3e8e78697eac05ae5b47"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d6970e081501b287f27119eeab1d5afdebacfdeb416d4f3e920cd3ad86e1e09" => :big_sur
    sha256 "cf6672c79d6bb083382d7d5090c7b8f38ac3fad9cc955e47b7d441f3883d1fcd" => :arm64_big_sur
    sha256 "f3198b2f700c0265ea488cb003bd0eebb17ef2438627a7d4afdc1317186c7d75" => :catalina
    sha256 "164d9398a64684d8a81540ace3a022a178ef0802d62ee18372900130445c1104" => :mojave
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "ab9ec7787593e310ac4d8187db3f6cee", \
      shell_output("echo Hello | #{bin}/dMagnetic "\
        "-vmode none -vcols 300 -vrows 300 -vecho -sres 1024x768 "\
        "-mag #{share}/games/dMagnetic/minitest.mag "\
        "-gfx #{share}/games/dMagnetic/minitest.gfx "\
        "| md5").strip
  end
end
