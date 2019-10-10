class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.0.tar.gz"
  sha256 "8a7b278b93b737daf46554fa83b86538b1f6eee02f8508eb08581aa578531f02"

  bottle do
    cellar :any_skip_relocation
    sha256 "722c652fc047a14a6de337a5636846ab8fece9d1f8b55e66877169702a7f02fc" => :mojave
    sha256 "7982ddd0e69261a3f8190fe8d7a85ef78c605a318b731820fb59e6b1344d349e" => :high_sierra
    sha256 "cd438f924dd26baed2e423e23f66f194721b825c2f04c9e290d39ee7db651c90" => :sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/master/rfc/2100.md"
    sha256 "0b5383917a0fbc0d2a4ef009d6ccd787444ce2e80c1ea06088cb96269ecf11f0"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/mmarkdown/mmark").install buildpath.children
    cd "src/github.com/mmarkdown/mmark" do
      system "go", "build", "-o", bin/"mmark"
      man1.install "mmark.1"
      prefix.install_metafiles
    end
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
