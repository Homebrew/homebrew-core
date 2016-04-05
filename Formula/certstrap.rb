class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap.git",
    :tag => "v1.0.0",
    :revision => "9671766fc7853ce55c64aebdada03dba918c9a95"

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
