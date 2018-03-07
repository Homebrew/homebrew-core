class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.37.1.tar.gz"
  sha256 "32ceca3bfcda80109ebd16b0cfdeb40c6b6fb1fe86976abdbd0fbce2e6492172"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "017939ba21c6b5e88ebb49e4b5f728656a1ab62cadf704a3d1792d8b1ff980c4" => :high_sierra
    sha256 "df82e9fe961e4076cd1bdf4ff6a5365011edee5256583549a71229b247c2902f" => :sierra
    sha256 "cf6133f0c53d323f5e6a6a991fea91137637c5104d61d7f5ed7716ec7a6ed206" => :el_capitan
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
