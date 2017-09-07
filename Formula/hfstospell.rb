class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.4.5/hfstospell-0.4.5.tar.gz"
  sha256 "cf10817d1d82f0a7268992ab6ccf475fae2d838e6b9fc59eb6db38e9c21a311e"

  bottle do
    cellar :any
    sha256 "70fe81e5ba05136921bf47c9e29053d1ab0c23ad729bc47daafc8b9fb0a311ab" => :sierra
    sha256 "9417cec27aed563db269d83402af875161724b10297ab78c4e69e4811c60866a" => :el_capitan
    sha256 "4dcc41f94c027f765b2d8e9e3859a72797d1d2f2e0e59b8f33ef47831dbcefea" => :yosemite
    sha256 "87cfbe776c920c653c7baf52d8492e6f2fc19a3c440026d09f0a8c05e3c26a87" => :mavericks
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
