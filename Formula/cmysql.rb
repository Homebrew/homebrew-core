$version = "2.0.2"
$hash = "b92c44c4fbcdc33be7a90f89051aeba8f4a3abb18fe5de7dbfac67ccd0aa98e1"

class Cmysql < Formula
  homepage "https://vapor.codes"
  url "https://github.com/vapor/cmysql/archive/#{$version}.tar.gz"
  sha256 $hash
  version $version

  depends_on "pkg-config" => :run
  depends_on "mysql" => :run

  def install
    system "mkdir pkgconfig"
    system "mv macos.pc pkgconfig/cmysql.pc"
    lib.install "pkgconfig"
  end
end