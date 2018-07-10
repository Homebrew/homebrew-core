class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.43.tar.gz"
  sha256 "6a263844847b9676a38b7a687fda77f47e7cc39cdff7a9c1234a7afeec7baddb"
  revision 1
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "940c8627d1399d766c4d73f9b6f4ac06d379d0d428f928c58dac6c685844bd21" => :high_sierra
    sha256 "7a6b58e05988d05bceec71b6c424253fcab98ae761b7ef845f8f25b3cf74d367" => :sierra
    sha256 "5629512f3d72bd5a9c57d885d04a11746cb682e6db2179722aaabf12a6d82cac" => :el_capitan
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
