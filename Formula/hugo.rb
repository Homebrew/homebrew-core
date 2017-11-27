class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.31.1.tar.gz"
  sha256 "90613bb2992a142e7997bd164d06c1ff003ffbac5ec882ca0d6bc996bc16a2c2"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa3bfe4db9946ea6ba80fc0fc0a8c76bb2273cdb251537f04771b24017bb1a6f" => :high_sierra
    sha256 "738d3ee9ce9d45deedcd26145b82e097907da7628ecbba6b875386f872c861e1" => :sierra
    sha256 "6b511023f2096d5afca0f3b1f7c1eef6cf8ddb4944040a4ed550fdb0c8cbdfda" => :el_capitan
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
