class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.4.5/hfstospell-0.4.5.tar.gz"
  sha256 "cf10817d1d82f0a7268992ab6ccf475fae2d838e6b9fc59eb6db38e9c21a311e"
  revision 2

  bottle do
    cellar :any
    sha256 "bec1f8ca18b8a020b58301ce2a5d94066d2dcf658c821a88a573f8182d420f04" => :high_sierra
    sha256 "efe7a12501e504209e44ac1a866c168ab98ca3d8979e49871c92d2e362966cc2" => :sierra
    sha256 "71e32cd4dc6e95ab4b09c1a5642233eb2f94fe1d97bc36ddfb7e13654e5dd307" => :el_capitan
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
