class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.1.1.tar.gz"
  sha256 "c69bbeb263ca38c528016094fc299585fe8804db0c80f123c994cdec0c191716"

  bottle do
    cellar :any_skip_relocation
    sha256 "722c652fc047a14a6de337a5636846ab8fece9d1f8b55e66877169702a7f02fc" => :mojave
    sha256 "7982ddd0e69261a3f8190fe8d7a85ef78c605a318b731820fb59e6b1344d349e" => :high_sierra
    sha256 "cd438f924dd26baed2e423e23f66f194721b825c2f04c9e290d39ee7db651c90" => :sierra
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
