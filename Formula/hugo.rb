class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.100.2.tar.gz"
  sha256 "651b0fe2c2c97be016066a6fcb53ef262a2bf5237cc370003a75489fb64b0a25"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d43c18d7710d00bdd2677c9f23856d466dd6bf701992e1016c82ecef6aaf371"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bab66095858a7be375003fe98c0baf5e4042b53ef0090566691a42031c64d89d"
    sha256 cellar: :any_skip_relocation, monterey:       "ef95f6c22b736837f79167d4fa92879f2b89d389ebdaf2e47cbbd81055751efd"
    sha256 cellar: :any_skip_relocation, big_sur:        "eea7e2f91139c9292d2a5e0674c9d3eaa349173e6a3e8f53914646ff9eeaf9dc"
    sha256 cellar: :any_skip_relocation, catalina:       "6f785aaf90012095b0889ae826726e4a68a10f07d7151e8b1b9478a61e2afa5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031b0bb0e2aa52a9744f408ba2b964302b0b24a92c81ba30e1269a26936a3c1a"
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
