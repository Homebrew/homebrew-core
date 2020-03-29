class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.68.3.tar.gz"
  sha256 "38e743605e45e3aafd9563feb9e78477e72d79535ce83b56b243ff991d3a2b6e"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "202cb22f91d546939c3e7d11a360b39eb67e445b41f8a8114c35c6cb26d7a7d1" => :catalina
    sha256 "9b93809ed925204a4d34458044e5d81e152c43c10debaf87509007f45b84bec3" => :mojave
    sha256 "71684aacddbb3d971ea53de453cc8de91c15501ef3db9fab5077a43aa6bd73ee" => :high_sierra
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
