class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.63.2.tar.gz"
  sha256 "3b23b3738a2b2781aca8dbd4859782804fa1142d71d38c2144d04299f9030e6a"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79c72c25df497e3cd18cbf0097d7910723ac54a3ac909e312bc75f646dc25801" => :catalina
    sha256 "250a50f5cbe8c96a3b491c98ee1fc2fe72b2084261632d9234a3ffbc515e8152" => :mojave
    sha256 "12d286b54812d1d218bcb7f3eeaf9ceb4c7dc13ff93b2cc5d101d5c77f3fb9d6" => :high_sierra
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
