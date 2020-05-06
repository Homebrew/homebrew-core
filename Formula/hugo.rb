class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.70.0.tar.gz"
  sha256 "4d1df7a7fbd91706dbf3d83f250230cfdcc2076cc0dcb4147971f80add2ee751"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5475404be99b2072cb4d092b41317877d8c86416405ffcdb6d5058bcb06c362" => :catalina
    sha256 "240f349f7198311bded718c0c7883ece279281d715a16176a4a93cc92a5328d1" => :mojave
    sha256 "4cff51a3dd71cb532bdca39a62650d46d2c489b62b71285abb28803e5bc39c6b" => :high_sierra
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
