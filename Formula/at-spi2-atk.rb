class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.24/at-spi2-atk-2.24.1.tar.xz"
  sha256 "60dc90ac4f74b8ffe96a9363c25208a443b381bacecfefea6de549f20ed6957d"

  bottle do
    cellar :any
    sha256 "44d6a555162dea2049305e93f37f8537097bcd4db382a33c46f0cb41a01f41d3" => :sierra
    sha256 "8fec3a70477bdcf8381f08decf4dbac2f33c991233c840f24e42cf11164a134b" => :el_capitan
    sha256 "90c79a2b1a7e4b9e929c43d8de86fb66b17799fa8bf6334b7f64098c47bff262" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
