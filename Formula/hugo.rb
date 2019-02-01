class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.54.0.tar.gz"
  sha256 "fe0f4d4542491706cc19cb8c0acd63f1d9989cfbeaaad39d93031e91bf73fd91"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f36408ebfb9e48b651bffe5be2c2fe2ffa5cb894daa8ca58089b427c34019189" => :mojave
    sha256 "eb3ff4a9b067e2d3519aee7bd819c8998fcf9b23620568d13c1ee05c33f8ccf3" => :high_sierra
    sha256 "a9f35ce528ff47354fb9509fb31054597e3b197179ccb83b73e26c53ff376356" => :sierra
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
