class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.48.tar.gz"
  sha256 "0fa6bf285fc586fccacbf782017a5c0c9d164f6bf0670b12dd21526b32328cb2"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "15301cbfe95b5b3dbefd02ecbd59bd1155fff891f6c027e226db196090446526" => :mojave
    sha256 "357be80e0723b7ba0684be4825a66fb8ce57ee72115040d7d8feed04a68d3b2f" => :high_sierra
    sha256 "c3eea992e8609032631c1fcdf071e6196bb9249b377b1220a1f275522abbfc9b" => :sierra
    sha256 "63d95d7fd585d159474e1618929da9fae205dd0f7dd674083e804e7607d54c83" => :el_capitan
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
