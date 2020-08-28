class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.1/hfstospell-0.5.1.tar.gz"
  sha256 "ccf5f3b06bcdc5636365e753b9f7fad9c11dfe483272061700a905b3d65ac750"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://github.com/hfst/hfst-ospell/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "82553e62189a1eeb0a759f5a0dddc57c21c6545ee35f1b59338c3fb0efca765f" => :catalina
    sha256 "4ed2a4a266fad9dd113fe2221bff23b460c9e50bb956b1eba5b8ba15fb756626" => :mojave
    sha256 "f5ebd7bb299f5e660c8b559bed232bc6fc6ec4ea98691384d385f3afcf4a6c96" => :high_sierra
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
