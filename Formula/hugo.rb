class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.78.1.tar.gz"
  sha256 "607502a8678fc7134f3df1ce2978f31e407ac0cb1d6b61e46cdcc9883ce12af8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94c5007729bf092105a2d17f5a5ad1c8d2c600f8800d2e0ccf69e2f3633d7847" => :catalina
    sha256 "deb531bceb1aaaaacfe955fe22abe878beb0a4ef8fbce9b6cfd6d1b4f0de605b" => :mojave
    sha256 "ecb753c76326fe1c34382e96d51e6a93f66066dca0013bdf4945e25c085535c9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

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
