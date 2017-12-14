class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.4.5/hfstospell-0.4.5.tar.gz"
  sha256 "cf10817d1d82f0a7268992ab6ccf475fae2d838e6b9fc59eb6db38e9c21a311e"
  revision 2

  bottle do
    cellar :any
    sha256 "2314e93dcc176c5f9e9da0abefc25fd1ec7367eef0aa36a1d84ff2032a770304" => :high_sierra
    sha256 "bc9c8a3a8aa90fd6fa47b6137f6d7a5382bf93a1af4968598645bb065c8982c7" => :sierra
    sha256 "8b1cb189c4c13aa258ac656807821409932ff161392c663ef0ad5fd217282483" => :el_capitan
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
