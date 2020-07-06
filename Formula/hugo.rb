class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.73.0.tar.gz"
  sha256 "36e106c96b6c66bd558759a069b227f797a996235a39bb6fa0397fa32eb8434a"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "173fee6f7220cdd918bafc73a89437ba4773fd1feef0834fdaa959ff2767382e" => :catalina
    sha256 "ffdb7c0c2612cff9551889405bb9d8ccd2de37516957ee7ca5e78af03ac9f315" => :mojave
    sha256 "0659e118aa3816c8c9c19c7399f3178f6557217f2d507f4e73f73907e045f244" => :high_sierra
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
