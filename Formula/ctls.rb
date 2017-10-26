$version = "1.1.1"
$hash = "6bf5cf1948df21ce8886bb9016dcf1f02d400c8fad603be8e464556d1382893a"

class Ctls < Formula
  homepage "https://vapor.codes"
  url "https://github.com/vapor/ctls/archive/#{$version}.tar.gz"
  sha256 $hash
  version $version

  depends_on "pkg-config" => :run
  depends_on "openssl" => :run

  def install
    system "mkdir pkgconfig"
    system "mv macos.pc pkgconfig/ctls.pc"
    lib.install "pkgconfig"
  end
end