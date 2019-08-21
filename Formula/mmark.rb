class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.60.tar.gz"
  sha256 "b48a83a6bad81e6a0802453dc93be2e289f9e67b3482b86486cec5c590ec4f9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "39133dc4406529c18532b9e67d3688b5a056c1ec822df6f3ee910536a62ee798" => :mojave
    sha256 "cce71bd7f72a8bb55355ac3aa03d59ca1d90cda23ee2b516e1ecbf7c36e54551" => :high_sierra
    sha256 "e25e71fa69d72fa674633d24887c1cf86eff7ca6fa8aff2fd3e9401c793bd7e0" => :sierra
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
