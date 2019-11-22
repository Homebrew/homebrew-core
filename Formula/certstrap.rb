class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.2.0.tar.gz"
  sha256 "0eebcc515ca1a3e945d0460386829c0cdd61e67c536ec858baa07986cb5e64f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "154b80812c45ee86c241fac030f98ef5fc368021c0dd6fbebde4fd4a9dbf6803" => :catalina
    sha256 "b7eb23b913b4f2bdb3d854a6e22f1b25c71018d369fffeec5a16b8df8eaf1fe8" => :mojave
    sha256 "4dd108d82d046be8576b460d9a2878d593669fa5b11cd015c6aa1f9fc26134f3" => :high_sierra
    sha256 "aa650a24795207c8860ba986e34f2d320a218b8ee414bd73a5390aaf25e6d214" => :sierra
  end

  depends_on "go" => :build

  def install
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
