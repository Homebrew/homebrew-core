class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.88.1.tar.gz"
  sha256 "da5f52437bfc7521b194b39d36a8cf7b2775e70e1ba8c443f81a14f468608507"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b815e48af3443fc123ce4d874cf038c25b798ea1944c960618ba3f036020e631"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6afb880f736b66dd33aa5cdb18e413c9e0a80e21b4c86c6812d6a90876ba5ac"
    sha256 cellar: :any_skip_relocation, catalina:      "9f64eca55c2fcd01c1adf31652f36bcd1ba9c2999d484529cc90b333934f211c"
    sha256 cellar: :any_skip_relocation, mojave:        "990e77d348ce7de0fc82893aaa039148b10543f61b872d4f89bfbb540bdecc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1d3cd5fb7a2510a25b2c8cd8814b4f289b1cb51b563326d71ba9f7808063dd0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
    bash_completion.install "hugo.sh"

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
