class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.22.1.tar.gz"
  sha256 "cb7b5a653595e0c19f4509c15cd18a3d64df53689e6c028bdd9dfef74a4414ce"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae2e031346c156a2a9b625be154ca0b750732e9a10291682c099b7c07fc2908b" => :sierra
    sha256 "c7492741edbb2aa6580ce870653cfa9ec003092f2bc7566977425bc2e250ab7f" => :el_capitan
    sha256 "7bcdc0b0033c8bf2d7c2a73deebe23f1082bb9b44aab7f0575e0e724cfc97545" => :yosemite
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
