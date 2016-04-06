class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap.git",
    :tag => "v1.0.1",
    :revision => "c66ef6751a6e5a900c6d96cbdd0e3ee9b18792d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "113340ae23315f9a7e4edb3331eae2f05372e5cd33b79cdad3cd0d29eee42cce" => :el_capitan
    sha256 "d227738fe010c1bd3a6a08b3237819fa4c9e4e456a814acda076d34371955330" => :yosemite
    sha256 "fa77e8e9473beef9d382e1de68f8cea0e3b4adb879a0adbb8790fcf55e8bac2c" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    system "./build"
    bin.install "bin/certstrap"
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
