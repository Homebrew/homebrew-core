class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.51.tar.gz"
  sha256 "0d0c41b3b1fa6d9847bbf72b711522b6bd493bc85f2946985b271c9ab6c13be5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f81c76050c205deaf9a2378d447ee2321ea22042ff4a0364d67af41d64c30e62" => :mojave
    sha256 "8f3d90d4b75894cf9a976c767ef6d6a729b9148ca6e2a86248edc0868c9bb5ae" => :high_sierra
    sha256 "0ef2e9b31ab20f16f85aebf91ede6d935db66966f4f2d20146cc918d7ef48188" => :sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.0.7/rfc/2100.md"
    sha256 "2d220e566f8b6d18cf584290296c45892fe1a010c38d96fb52a342e3d0deda30"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    (buildpath/"src/github.com/mmarkdown/mmark").install buildpath.children
    cd "src/github.com/mmarkdown/mmark" do
      system "go", "build", "-o", bin/"mmark"
      man1.install "mmark.1"
      prefix.install_metafiles
    end
  end

  test do
    resource("test").stage do
      system "#{bin}/mmark", "-2", "-ast", "2100.md"
    end
  end
end
