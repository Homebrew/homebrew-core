class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.42.1.tar.gz"
  sha256 "4450c9434269dac75f4a6cb702d8704a49c73e17f974dc2fa15e699c03b9774b"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37e46bdbd0794d239ef75825b5a84d95f1c46b49bd2449f48cd4b26841d6b151" => :high_sierra
    sha256 "a69b23ec21a4c6a4f0d5237b8c5502f3fd205cbc46ffc81eab918282d34ad63c" => :sierra
    sha256 "6b1c9829307fdd69f0b4c0d09a7ee8dd3d37f3733023d52b4ff593e4a965e93c" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"hugo", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
