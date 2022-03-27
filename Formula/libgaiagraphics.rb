class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 8

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/"
    regex(/href=.*?libgaiagraphics[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "bed66e6333951fdaa247237dda24a2aeba7dd4da38bff9f2a5cee773ccad6179"
    sha256 cellar: :any,                 arm64_big_sur:  "91a013bc4758557a34fca5662d16d09f2b76e2b4c6e3177289e4c2159a2bcf7d"
    sha256 cellar: :any,                 monterey:       "6b722c74991746345bf03c04ca65446688d2731e06a4a14053f2fa253860d915"
    sha256 cellar: :any,                 big_sur:        "28b19c8fffd8c7dc4e2b24ca6e15d510f1743e54bba8fb438c99889defea6c7f"
    sha256 cellar: :any,                 catalina:       "ea27d6a1177791c4c0acf15e2c8a59c993262836bfe7a21721b67846eec69d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb275f995ab7b5f3fa57f74399527e00839184943eb08773cad8d6cba5e396b"
  end

  deprecate! date: "2022-03-05", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "proj@7"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
