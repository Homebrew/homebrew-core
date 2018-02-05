class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.36.tar.gz"
  sha256 "fb71f1f847528116e3227ed34050f731f5bae0246c861a97567a0ce437f877a7"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b2557b7ff7a6cdcd470562d432d6bd9bc03e182c94577a3ddbd24e019c5ead1" => :high_sierra
    sha256 "d7f16deed518966d73f04bfc1e922d79868debdb098cc0a9cd966f067a35f405" => :sierra
    sha256 "e17cb2ad05cab072bf75c957a23caf0c56896639d3e75a9f59266e3b8c899242" => :el_capitan
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
