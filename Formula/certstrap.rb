class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.2.0.tar.gz"
  sha256 "0eebcc515ca1a3e945d0460386829c0cdd61e67c536ec858baa07986cb5e64f8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52e68d4bcd2256bb1026aafefc9aef39c0e7945e1f26c06b3e09f3b7e7d9ab14" => :catalina
    sha256 "8f7fb0f6d8b559ee4d30972a68d5d76117a86c07233abc49237c516f45f07277" => :mojave
    sha256 "12fdf1f518c3f2944d30f4289813a82aa56580b844fc2cc1ad3383d8675c9882" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"certstrap"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
