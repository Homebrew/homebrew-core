class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.5.tar.gz"
  sha256 "1c259a29b21c9f401c12fc24d555aca4f4ff171873be56fb44c0c9402c61beaa"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url "https://fizmo.spellbreaker.org/download/"
    regex(%r{href=.*?/fizmo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "a527d7b88baf8596cb681dbaae5991a8ecfb4ca9550e7c614e9a57826ec01e1a"
    sha256 arm64_big_sur:  "905aa012a245080a6c58ec78c646916b988642cefd0fdb544135e61b66a50e9a"
    sha256 monterey:       "84900dce82bfd6082f4237fc513536d1d506908a86df7067a36d858d41c6c45f"
    sha256 big_sur:        "620198d285ed205b8feb79aae7f04be8450bbf32b627536cec8aa48caf91eaf7"
    sha256 catalina:       "9f84f5f3d0f97f9637ad66d6d7906c53bd794518eab45c22f4eb51c153e31ac8"
    sha256 mojave:         "e37b186ac0ed5c8cdf5f08a7f7bedd7e997454700b6b9a92e14c41f3afc4c9fd"
    sha256 high_sierra:    "16992ff53e0327dfc9bce300d6a1c3a2e6e0874faf9ef3fb7638c3267ae09788"
    sha256 x86_64_linux:   "d7eba39b8a87827af0ab002cc5d3b72d39b58c9a15acb1d96df14f1f06bb43e4"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libx11"
  depends_on "sdl2"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/fizmo-console", "--help"
    # Unable to test headless ncursew client
    # https://github.com/Homebrew/homebrew-games/pull/366
    # system "#{bin}/fizmo-ncursesw", "--help"
    system "#{bin}/fizmo-sdl2", "--help"
  end
end
