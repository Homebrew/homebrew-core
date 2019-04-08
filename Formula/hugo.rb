class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.55.0.tar.gz"
  sha256 "4601d29e174c1829476e0a821073bcac6fc468864fccaac05d91f09a779334d9"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb972dc07bdc26253eda33ab4aca6b8660eee660fbf5ade5f557ba912c1fc8ce" => :mojave
    sha256 "c8809dad0d4800a7862d92d90aaf8dbe1ac4b018dd5c36e34f0c146f663465c3" => :high_sierra
    sha256 "768bcec40e0b82a440010c4eec8cb1d6b56f1987f3a5cd61caa453acb9f60f3c" => :sierra
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
