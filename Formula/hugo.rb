class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.48.tar.gz"
  sha256 "0fa6bf285fc586fccacbf782017a5c0c9d164f6bf0670b12dd21526b32328cb2"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1faf58a3a7341912112228b2230f8ca2da286c73109d3b91b39d2f5bbec4922" => :mojave
    sha256 "8ebe8cd41fb9d04441f1f6c463132bbbde0351872c417f1a8ce421334ef69ace" => :high_sierra
    sha256 "124eaf994dc889997b41734c486a024215eb322089bded67e9fc98dcc95d3642" => :sierra
    sha256 "0b473bfff822f2b57b788fd88aea29dfd87be3439c5b13c8f5f4409c940a9c24" => :el_capitan
  end

  depends_on "go" => :build

  def install
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
