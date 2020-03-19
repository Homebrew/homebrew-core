class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.67.1.tar.gz"
  sha256 "e3f29dbe764a81eaef6d42bf95f0ab7ab3427ab83c9cced72f9ca4cf39753a90"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2506db6ed4413065469e9bc12ca32e99c91aaa2f2ad6f9faf8c6af4733022873" => :catalina
    sha256 "e612eab538824f80c6c07d7b0a32db7950596f9e3c14e74fee2af74fce7bbc5e" => :mojave
    sha256 "49fc95760a331ac5fa0d4286cea3d4e1822a8eb1de68845c351e64139b72d9c9" => :high_sierra
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
