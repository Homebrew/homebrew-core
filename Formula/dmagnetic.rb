class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.22.tar.bz2"
  sha256 "53905c8a1a69c5c69a7afcac5d0368edc6c214fc603f3d76313e4f33faeb0431"

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "2d90033c199915d2f4d4ecc964121928", \
      shell_output("echo Hello | #{bin}/dMagnetic -ini "\
        "#{share}/games/dMagnetic/dMagnetic.ini -mag "\
        "#{share}/games/dMagnetic/minitest.mag -gfx "\
        "#{share}/games/dMagnetic/minitest.gfx | md5").strip
  end
end
