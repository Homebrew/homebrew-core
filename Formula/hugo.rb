class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.97.1.tar.gz"
  sha256 "7f09745962cf6aac1d001537a049e1559dda4342bfcf1bb0778d0b1aea80708d"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f6b6d790e26f274c7432d5c9c13fae8d38a155a65c2e8fbd29eced8b9e4fea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fce5d847a4c3bff5ef30b659b1a32a466173e960ac5d0570adc89265cbbd6ab"
    sha256 cellar: :any_skip_relocation, monterey:       "976769748fa1e3228bc7508be0ff5143b9034cc31ed058b8598a3a6899d15a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad90f82dedb59c941a41ce998c3757ac7fa980b83a3d89f6e6cfb548a0f81061"
    sha256 cellar: :any_skip_relocation, catalina:       "a6d3fc62c12f44a166b5a7149fee6d1bdcf57bdd48f021002f5f938cf4870db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7524fb72541476f45fa935490d98f2d1d1434518e085e1c84e41034657063b6e"
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
