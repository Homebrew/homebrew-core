class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.4.5/hfstospell-0.4.5.tar.gz"
  sha256 "cf10817d1d82f0a7268992ab6ccf475fae2d838e6b9fc59eb6db38e9c21a311e"
  revision 1

  bottle do
    cellar :any
    sha256 "4caf4783345654c7cdea9d47ffabc6cfb4b77f01d98de626e6b0e65c4e5cb7ac" => :high_sierra
    sha256 "6d42bafd9ece439af37329183b65644973e8a64bf1b4a93a13fe543d8ecdbe38" => :sierra
    sha256 "e6c21f06dc9a48e9106b26598db0fad40f4cf98310818e4ec1659ca5228614e9" => :el_capitan
    sha256 "749db395f939581fbf9c7302caea13f7defab3d14d76e8829e0d2e50f7673558" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
