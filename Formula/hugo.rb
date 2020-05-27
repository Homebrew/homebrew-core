class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.71.1.tar.gz"
  sha256 "4157a023059e199a1912d3c8026144c4b1c41cdbde7f1ffc826dd7ac01bb7b76"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9762374091d493b7c4ba75b0a53ca15475cc3ba418e7ef255f7900fcb7fd6c51" => :catalina
    sha256 "f2651ecf17010ce93db3c4d01a9dc4c247dfeee2c8076cc8bea4b245413c9694" => :mojave
    sha256 "810cf23bd40a9dd650d90433faaa2ccb4cb7dbba48ad1be3fbc38faf9ad660f6" => :high_sierra
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
