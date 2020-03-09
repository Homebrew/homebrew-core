class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.67.0.tar.gz"
  sha256 "2a1446ae9cec7ee3a6e2efd282146cba78de0e8a454d41ea57df0ab3154e5fdf"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8eb42640a7344366faad179974974127d1d3ddd95a9603b71d80308f4b1cacc" => :catalina
    sha256 "d4fbd66ecdbd4ccbf7d5e7fe00f9b38716862be8fe067266b3d3b60a91dc18e8" => :mojave
    sha256 "d65886d28f029eda5230c296a5de24e16ef636ecce7d938997a7a954d10f33c6" => :high_sierra
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
