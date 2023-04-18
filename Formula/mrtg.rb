class Mrtg < Formula
  desc "Multi router traffic grapher"
  homepage "https://oss.oetiker.ch/mrtg/"
  url "https://oss.oetiker.ch/mrtg/pub/mrtg-2.17.10.tar.gz"
  sha256 "c7f11cb5e217a500d87ee3b5d26c58a8652edbc0d3291688bb792b010fae43ac"

  livecheck do
    url "https://oss.oetiker.ch/mrtg/pub/"
    regex(/href=.*?mrtg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3dc3ce6e2425a2c461ce3beef08a2f16a7141a3b427c5ecc334da566619c2065"
    sha256 cellar: :any,                 arm64_monterey: "df8611100c34ebb4c553b81493006f954fca61669b4a6331914529bce73a6348"
    sha256 cellar: :any,                 arm64_big_sur:  "fedc3e50c0a75c2ae6e719a1ef5502ce38efdba9e51d0f9201d2ad02d5c0a1db"
    sha256 cellar: :any,                 ventura:        "e7a1b7cf6468e3ff41eb63860fd61887658eea6fac2fec29c30f97ed8491f893"
    sha256 cellar: :any,                 monterey:       "47c8ae5d5466514d50393ec5f48219313a2a9b7b1544b08dd923bf1e5642762e"
    sha256 cellar: :any,                 big_sur:        "28151b3e97ec16b70623caab573a79eddbb2e86ab8c25812e3339ac9612c38f5"
    sha256 cellar: :any,                 catalina:       "a9cf00745f42b6db7026d3954948319f2528526099a6aa7386c63224952f1732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d13a8441a4958962e6812e1811c529021505443bf4fb5cde24214f8cc1332a"
  end

  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cfgmaker", "--nointerfaces", "localhost"
  end
end
