class LibsvgCairo < Formula
  desc "SVG rendering library using Cairo"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz"
  sha256 "a380be6a78ec2938100ce904363815a94068fca372c666b8cc82aa8711a0215c"
  revision 2

  bottle do
    cellar :any
    sha256 "63cfba79036bfd190a92e6a4c501e2e4c737bf63e6a8df6bdca56885c66ae740" => :sierra
    sha256 "9f87cc3a6d7e702aab12b23ad1f720ae592bdfb9112753e27c9cf2203dc21915" => :el_capitan
    sha256 "55bd8f9bfede25e71e9731d72ace27ce7724a4cce030a4e4e6969554ee64238d" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg"
  depends_on "libpng"
  depends_on "cairo"

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
