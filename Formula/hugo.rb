class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.25.1.tar.gz"
  sha256 "12f77c87cdc0bf4c6886a4c3343ba80bfe8bceeabed7a37e9dae945fa9010d1d"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "191ea58fd2a160caa8dc90f7a231767ddf38e2b0a24bffdad2d26d969d0ec5f0" => :sierra
    sha256 "c7eec34b7898afa345ea3b2298261184869efe450b370d47f1f351cf3327f031" => :el_capitan
    sha256 "2270e21cb841934df507a7d953722e80578f2e23c40d325931e79710a923476a" => :yosemite
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
