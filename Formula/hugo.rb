class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.20.1.tar.gz"
  sha256 "86eeda08232f28ad5b8426c9eca71db69b8622627bef43ae298c12724f35e30e"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fd7098b2585e56726b2bf2c43e9f597ec48f7f31f1669e80f8e1a53e689dbc4" => :sierra
    sha256 "a383b676f6622269900955de2a42ade033cad2f654eb09e81bcf83d785996f95" => :el_capitan
    sha256 "681c85b5ad572d256babf61fae51b236fc16a8554fe78acb1a55f3a92fc3a145" => :yosemite
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
