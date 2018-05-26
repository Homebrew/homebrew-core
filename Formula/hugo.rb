class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.41.tar.gz"
  sha256 "a5a435d352ad8df3f0dd77968e6ac21925ee006e5538a37f775d9f53b30799fc"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf4dc0bf383b6562bd4313da4cfb43b4ae68cba3597a402fbfffce80d79afe53" => :high_sierra
    sha256 "cacd89dae600abc5c979c3d541568e478cd734ce4ae6ae167d3d76ea50c77d56" => :sierra
    sha256 "4947fc7d2fb9cbae066aa6a23905e9122c48328d0dacdc3a5c203abbe4a5247d" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure"
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
