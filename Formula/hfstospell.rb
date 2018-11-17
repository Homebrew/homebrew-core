class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.1/hfstospell-0.5.1.tar.gz"
  sha256 "ccf5f3b06bcdc5636365e753b9f7fad9c11dfe483272061700a905b3d65ac750"

  bottle do
    cellar :any
    sha256 "83198b2c45b82d445d6acd6ddac8de7c6e2fab365c3d6adb7a7d6cd7c9938851" => :mojave
    sha256 "69927247be97c86e0802dc26cbd5528ee1723c100aac2b4b864e2bf4abd0081e" => :high_sierra
    sha256 "2dab570b4bc6ae2569e344843b2e8010138ebbe6930e85944d8a9a3d956d1451" => :sierra
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
