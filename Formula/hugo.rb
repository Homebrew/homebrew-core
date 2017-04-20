class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.20.2.tar.gz"
  sha256 "7d3279de4b829b5def468669c1e5e9a72e4cf30460a8ab6b045aeb6f98a6da77"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "668e874a4b11af3539a3cc738581395e780cb414afba0f649483860fb0997237" => :sierra
    sha256 "eed0528b33376e264fd36fabdcd17cca47dfe691fa9fcd3dccb0bac85276ec35" => :el_capitan
    sha256 "a043d390ee045feb4f71722f9d687a58183202656c1eb8ba1ce16f474657af5c" => :yosemite
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
