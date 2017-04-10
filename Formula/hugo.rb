class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.20.tar.gz"
  sha256 "e330956b5086aba3443366b98b4752e6ddfa8f91510660a3d620383d0f30b328"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61d99bd31e79a83c1bd66db042293c9ffef6e504cb7fecc8f77b257675c4964c" => :sierra
    sha256 "bcf37ee1d81061a195007952ddc7741b71f3c3b3aefe772852336c1584f6a397" => :el_capitan
    sha256 "9fd791588839ca46721e78d918d8061d6ea99e810cf56f78fe35db94ef383816" => :yosemite
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
