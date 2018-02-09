class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.36.tar.gz"
  sha256 "fb71f1f847528116e3227ed34050f731f5bae0246c861a97567a0ce437f877a7"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "099cf5465c570be0e8851a86a1ec984dfb15cd39ad571fcd6bcee3fc30461983" => :high_sierra
    sha256 "46d04366aa9e66a9c933ed4f9e951ac820e5aab4823635a47c0e6835f9f354d8" => :sierra
    sha256 "1d017e1d4ba51cf4cd7e0f27dd88a7d3aed089d2ceb4eec012a5a1e22ed9c907" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure"
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
