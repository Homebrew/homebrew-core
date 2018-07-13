class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.44.tar.gz"
  sha256 "63e6ae4be7e7b23ab5551842182b49be9a9a07a82d217c1a7a2815b49976129d"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7328049dec0c12bece16306258592277ab8b908c4e0dd797aa1a97a268d5468f" => :high_sierra
    sha256 "3dfc69ce3d591f893a69dffe93d8bf913de01b994f6ab387b19b6ec874e91549" => :sierra
    sha256 "52918c9fc8e42ee64cfc506f8129bad0301b8ebace96e1fbdbe4b47a6c144fc9" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure", "-vendor-only"
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
