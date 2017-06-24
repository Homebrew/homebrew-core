class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.24.1.tar.gz"
  sha256 "c7a5d56b528dde7c8a12044f7ede1f9d8c1c8401969ebef9a11695d00f8d3d55"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "303d04ede7878512743b30a56039941596dbe09eee11291f76c4b0e37f0a9e9c" => :sierra
    sha256 "ba2b6f5584e4fd03cfa6d4b3455eeb7f582c41a5fc317229017860df9417b09d" => :el_capitan
    sha256 "0be49948a3c8d7d2d935cfa325390344a9bbb91f44911c996aa77cb8e296f46f" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
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
