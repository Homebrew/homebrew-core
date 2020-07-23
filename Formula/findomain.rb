class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/2.1.1.tar.gz"
  sha256 "ff5f4cdf4b7eaf1401041916cb30a887fa76149711430e97c296a481c04d7f64"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3d2418cc9a2569d7d1c26113e4713a559b6733d22757fe1754dda7001fcc2b2" => :catalina
    sha256 "7a9c27967b1c1db830aeac80d8cffc8d520a9e01b9193a02e228ae27cb16ddfc" => :mojave
    sha256 "2052d47ab2c3c721f4efcfac71310147681bf430939ba8b0b72733b8dfe3ac99" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
