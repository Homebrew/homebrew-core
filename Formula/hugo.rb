class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.29.tar.gz"
  sha256 "8b8025472b7699e52a5f6b0cec0a5339130159b1d6ab5d281ed2fc69c97f48c0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any
    sha256 "979dfbe8e7fba439d883e2cfbb806d98c9e1a1fcf9def579a67798cbb1a0556f" => :high_sierra
    sha256 "c7beafd8a0feda1cc6e13ce85a3f13dbb3cd88f44a75ed19e3f0693b19e49720" => :sierra
    sha256 "3502c90885eb6c8fb0254a7cc717f4e33e40e36cb3fa483b62f034d899a0c2d9" => :el_capitan
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
    assert File.exist?("#{site}/config.toml")
  end
end
