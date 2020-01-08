class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.62.2.tar.gz"
  sha256 "e3a16c3096b489f097076058e9e8e3a40706d99388c475c8354eacb24ff37a79"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "354545c2c125e01a8860f83577fb4218d585fa8d38cd7f51e4228a149347fbcf" => :catalina
    sha256 "9645b64fe6290c4c3b7591ef21139247f0fad6e49da1edd01665b3130a8f1d1a" => :mojave
    sha256 "0ede4cbcc7536dd6b05107376637840356062273d734b4106be98b3d1732d50c" => :high_sierra
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
