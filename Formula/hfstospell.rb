class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.1/hfstospell-0.5.1.tar.gz"
  sha256 "ccf5f3b06bcdc5636365e753b9f7fad9c11dfe483272061700a905b3d65ac750"

  bottle do
    cellar :any
    sha256 "686d0c070747980c0ba5305cb5a75e71d3c0f30d94701829553b6b71a09cca1a" => :catalina
    sha256 "9c6c69212f1e6784eba39c412fee40fc7f67e113f0ce905573d71dd1ea3e1c5e" => :mojave
    sha256 "2f9c344944d7e1ab33854b091421df503a9ae7b6d1ac052b3879616e85173086" => :high_sierra
    sha256 "75b751ea37a89444b7f815d3fb356c8fd8bbe6c60a07161f966bb32719431235" => :sierra
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
