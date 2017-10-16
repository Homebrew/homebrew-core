class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.30.tar.gz"
  sha256 "12ececf96c401ce401d8f9b77923c91bba9d212d1cb6543de61862e7e8482231"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "63cba968a9a1419c2d43a0db0990515c88e08309272fb8993440473d92569627" => :high_sierra
    sha256 "561b4fb351c31f231daa4a1f1f0b8d6b6f698cc16ea00ced60be38ef5466a3d1" => :sierra
    sha256 "8dafb4055c0dbc8b76e92ed3c57c98c9e138d08160f7ff281375aea6cc40699d" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "govendor", "sync"
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
