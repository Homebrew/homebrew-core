class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/7.1.0.tar.gz"
  sha256 "58a95e6b714e41efc804eca389a223309169b2def35e57fa934482a6b47c27e7"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3e914c528b75e3057342e16b096aec7ea835347cba55c045d9d8f6ec288c7ab6"
  end

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
