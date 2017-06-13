class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.22.1.tar.gz"
  sha256 "cb7b5a653595e0c19f4509c15cd18a3d64df53689e6c028bdd9dfef74a4414ce"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c1aac4a349b279ccaf7e2e0049026a917774816a489a6f98fcf848ab9b9d2fc" => :sierra
    sha256 "2f337a3c3252237c8a18597fbaf9d25e15a3f4aea08ab0d15ce00374902a6992" => :el_capitan
    sha256 "d9f6be3d1ff0c139aa57300b85613bf907cd8c84d5597af263006512f1f0fca4" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/spf13/hugo").install buildpath.children
    cd "src/github.com/spf13/hugo" do
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
