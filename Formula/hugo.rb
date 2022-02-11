class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.92.2.tar.gz"
  sha256 "00d61205f426587dcfc4e2844a6f9fb451c825b828c00f0b46e3d0930c132751"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f183cf1c0aa22d1bc11839e2a1ce221cac87687616e4131fdba0f248f0562181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0eb38eac79fa9c192260eeffa2d538ec26d3ce52e864d8ea8522b96ceadbd761"
    sha256 cellar: :any_skip_relocation, monterey:       "93a67b3259d2765281a166269f3bb82489aff423abdf2291dbab10e284ff6d07"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ed5f8f4cad8aa8f817f6cc674e977983da1d9801893bca067974a18132c62c7"
    sha256 cellar: :any_skip_relocation, catalina:       "5d90d931f2a5c22c754f847f00330d135b2ab0fc49a6213d8bf04c055a513242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af83001d0ca9e03007cafe6b420b778719ef456fa3e44981e2807aca5a7aae73"
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
