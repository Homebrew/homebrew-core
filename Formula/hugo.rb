class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.93.1.tar.gz"
  sha256 "b21d83c1011a785ab28716227849d661671e00ed9c43b195789835d439d0d60e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b07a7b0c6fadf1142fc1d096f893a607f08434f21ecf92980f3c280611f78f83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeb5c89c71a4c42d86c19ce2c736babbed680e0ff4043f7424e772734c9fd37a"
    sha256 cellar: :any_skip_relocation, monterey:       "9cc3e858b326b996620ee02a7443af80a72e2d30a924eac0a5d0bbd5d4f0617b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6511411029229cc7a57d8f9a89e0ce8fe9b093b72e9f41b2e3f97208d0c8637"
    sha256 cellar: :any_skip_relocation, catalina:       "ab3d137803462dfc7451495f525f72447c8af9137c6fb3daa294c6b7dedd1733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd54c70a9e3ef51f7b7cc3dc2f86376ecc4bde512b1de6aff5827b05128662f0"
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
