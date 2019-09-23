class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.2.0.tar.gz"
  sha256 "0eebcc515ca1a3e945d0460386829c0cdd61e67c536ec858baa07986cb5e64f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f9e9e2396f8399f8ac9aaea91179bded59b4aac7a2928ed3f5e615c84388e9c" => :mojave
    sha256 "2151866d10f1ba703fbdc8b11632da00eb3588d4041be018721fcaf6278fec14" => :high_sierra
    sha256 "58a68f5a88ff0dc4321aeac2aad21fef2edfa85564d6766d3a9149ceebb2cf4b" => :sierra
    sha256 "dde1e9de937ea5cd7454bc7163a4fddd56ef75209edc7e6036121f57fa47fe23" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/square/certstrap"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-mod", "vendor", "-ldflags", "-X main.version=#{version}", "-o", bin/"certstrap"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
