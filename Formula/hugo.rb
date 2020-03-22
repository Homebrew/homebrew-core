class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.68.1.tar.gz"
  sha256 "eff3a6f9ded93e14c19f1adf60f22aeac593cdf4cd06866613f654f1e4790254"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c365e6b7e52342f5b05a0a7cbb3ba8c4540e6a297f383e3f578bb4ca65976a4c" => :catalina
    sha256 "d158b21786545a75d5a438a9275ee0df65fc7fc004290577b4fd93d049dbd8c2" => :mojave
    sha256 "f07ce6068d7ecdbad07e9f64c301594671bf80ba99ba63c8ac6fb18bb029eb8b" => :high_sierra
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
