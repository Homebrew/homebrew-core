class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.101.0.tar.gz"
  sha256 "ce5e2c37d9980428cfbfb22cabedc29aebe8f1142ce261777d0435f9f2d6d1cb"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c2de3fb12ae1261c4c2a62d2f4ebb26846f16185676bba7f5e1a22acafddf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b466d2fe9dc172b242f357de33a9d203f9670281182c65172cd6bc38746eda2e"
    sha256 cellar: :any_skip_relocation, monterey:       "d5c2216211b34cfacc3d717a78f270c066a1d5c00ff42cc69f11fd40b0ca0fef"
    sha256 cellar: :any_skip_relocation, big_sur:        "894e5b82a283c0637e098514e6a2da52ee8b07d74180bdc72459a91c4d7b3a84"
    sha256 cellar: :any_skip_relocation, catalina:       "754a78e3b73f62eb5d3d5af24fdb8a9d75a3d78a1cd1e0551ce2e8138494d66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590e776c859804bc442faab55e9575c50edd13a95999a563afe429576bd04aab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"hugo", "completion", "bash")
    (bash_completion/"hugo").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"hugo", "completion", "zsh")
    (zsh_completion/"_hugo").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"hugo", "completion", "fish")
    (fish_completion/"hugo.fish").write output

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
