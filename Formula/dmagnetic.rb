class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.29.tar.bz2"
  sha256 "a980e35f85c9661fe0d98c670f9d6be56000da2bbc8b3e8e78697eac05ae5b47"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ad041565df29641ea6fcc0d369d086bc37cdfd2a064dc2614ea8f6348862abb4" => :big_sur
    sha256 "df40d5425f12e4446e6a705204eb0291a1359c39edeb75a469b7f5a6a90197df" => :arm64_big_sur
    sha256 "cb486b657f277d01515a2996f31bc1afe08ccb7bbc28011a36adb7a2d2fb4f7f" => :catalina
    sha256 "d605e1ed5f3a3b86413b7bc8101a2f3ac3aaa2df76be7ebd2423ad9e43cc7547" => :mojave
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
