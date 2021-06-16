class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/7.1.0.tar.gz"
  sha256 "58a95e6b714e41efc804eca389a223309169b2def35e57fa934482a6b47c27e7"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da4b88eedb327e2c50fb80e39c5e2b453d447cc07be88479e11c8fdc26e128ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "65997eaa4358eba12ea2eaa20d3a7daa3b30acfae81aa447eab47894d808670e"
    sha256 cellar: :any_skip_relocation, catalina:      "9d88c0c07ebdeddaf68a5512a7f4a36cbc52851dfb1c6fc63b446f6a9baaaa01"
    sha256 cellar: :any_skip_relocation, mojave:        "9d88c0c07ebdeddaf68a5512a7f4a36cbc52851dfb1c6fc63b446f6a9baaaa01"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9d88c0c07ebdeddaf68a5512a7f4a36cbc52851dfb1c6fc63b446f6a9baaaa01"
  end

  depends_on "imagemagick"
  depends_on "screenresolution"

  def install
    inreplace "neofetch", "/usr/local", HOMEBREW_PREFIX
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
