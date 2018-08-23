class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.1.1.tar.gz"
  sha256 "412ba90a4a48d535682f3c7529191cd30cd7a731e57065dcf4242155cec49d5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f9e9e2396f8399f8ac9aaea91179bded59b4aac7a2928ed3f5e615c84388e9c" => :mojave
    sha256 "2151866d10f1ba703fbdc8b11632da00eb3588d4041be018721fcaf6278fec14" => :high_sierra
    sha256 "58a68f5a88ff0dc4321aeac2aad21fef2edfa85564d6766d3a9149ceebb2cf4b" => :sierra
    sha256 "dde1e9de937ea5cd7454bc7163a4fddd56ef75209edc7e6036121f57fa47fe23" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/square").mkpath
    ln_s buildpath, "src/github.com/square/certstrap"
    system "go", "build", "-o", bin/"certstrap"
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
