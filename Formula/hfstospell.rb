class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.1/hfstospell-0.5.1.tar.gz"
  sha256 "ccf5f3b06bcdc5636365e753b9f7fad9c11dfe483272061700a905b3d65ac750"

  bottle do
    cellar :any
    sha256 "eb7c707acd7379a1649e4a0a2f13a2851236b48f1779d2d5032a00a11ccd564b" => :catalina
    sha256 "0936c926d43a6be2fa7e083342eef56790b405fccd0f2686b49300f10239ec93" => :mojave
    sha256 "5862d60e06b3c1830515d689a4e28d6685ffd3beaf31ea58dc93ba4509212c1e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
