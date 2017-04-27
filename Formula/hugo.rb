class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.20.6.tar.gz"
  sha256 "857655b69fb3e7f174011fd6774501194f1241bbb833256fd63b585b6d7a3cc0"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "241fdbe611b16b66fa2e80487b6b894c08f3a1f1b2112bc9c724f3818fa4ee43" => :sierra
    sha256 "ce010ad89e78b4ed61bf6bfc79aae6632b15113014703b8ac0939500e249defc" => :el_capitan
    sha256 "c8681c7f725001cd7dfafbf7275873f36f2752adfffad6fc7e98576de1eb8f3e" => :yosemite
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
