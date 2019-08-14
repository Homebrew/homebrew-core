class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.57.0.tar.gz"
  sha256 "fe71e3dd5476cf3eb653ed9947d52a2001e20835f7b118fc6b0bf206c7f7a5fc"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "885f875849bcd54737ca9ddfc2eaaf88eff0b6d16c534893f471324a6ca5f531" => :mojave
    sha256 "6b878a8c88f97f638cce7ba4beda514339a3d5601ede8c98b47b0e1e2a50e995" => :high_sierra
    sha256 "04d5c5dd611b2a0a68d56f9b182b7d791451622d72254fd743d4476de9ab91b6" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

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
