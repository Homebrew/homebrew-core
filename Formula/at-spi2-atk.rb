class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.22/at-spi2-atk-2.22.0.tar.xz"
  sha256 "e8bdedbeb873eb229eb08c88e11d07713ec25ae175251648ad1a9da6c21113c1"

  bottle do
    cellar :any
    sha256 "ae9185cac55688d3189fba948f0715ea2fb50e1fe7bd21f7822ac02ef8830ebd" => :sierra
    sha256 "bac769fa1f39e95d37c5abf01d99e1e14e05489d9efd6e19415d07d81f2bd2cd" => :el_capitan
    sha256 "c1a1dd0a265a8b2a4ce9630c3408350459980e7e9258eb35bea3896e4e289805" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
