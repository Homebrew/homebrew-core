class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.94.0.tar.gz"
  sha256 "76f6ee1f9138c7f5562f02679576889d0087910c9a6e49ef16a5ebbefda9e917"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aca3d971c65db8b888687568a31d932ebe1ff181c56524d0faf4186558b81d90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d648e75f515efc0b2d118bf2ca3e7f0e3bbba17ecdae12e0cef537dce8721b5"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fd2daa88571fc6cce0a9fa4477a3509ad369c1c2d4917a6a6b0cfc11ce1e68"
    sha256 cellar: :any_skip_relocation, big_sur:        "95d0c2eceabde7c36eb5a6e4821b1db3fa65ad14b4b91fca73946d4b682cc318"
    sha256 cellar: :any_skip_relocation, catalina:       "864fc5ee5e3ffae9e2cbee05c8aa4651703c4492ea1c56da5b70d3ee1b3e4cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "051c2336f48dc924f0ad08a0d35e74d3a0838636a5769e81d290ea14b40d0d4d"
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
