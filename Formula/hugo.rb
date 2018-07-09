class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/releases/download/v0.43/hugo_extended_0.43_macOS-64bit.tar.gz"
  sha256 "efa015a17da945590a003c216c1a4c985b98e8acadf6e0c6c6d0261a786ee120"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f589cdfece817967ce1bbb27e5b1cf24df5199aa18e783194c0f2d51dc9ed6e" => :high_sierra
    sha256 "210e0672df44a26627c631b7c9a69752c708d142bdc6bb886b0af0baf61465d5" => :sierra
    sha256 "9b56ed7c92c849fa22a9486b0f78b29714d89485f90b677deab1e83a2f7b9500" => :el_capitan
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
