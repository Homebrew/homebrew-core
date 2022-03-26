class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.96.0.tar.gz"
  sha256 "5dbb132438b4ae3dd8303b34c8b7480674ee77236ac3d36d0edc82a06a0c3219"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26531e2d219e612e6925b86d0d23db71d287bf91ff099c4bca01bd425391ca2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f9b9f019f06540be0413ab0b90957d9069475ab0b7c85b462636f47b46972f"
    sha256 cellar: :any_skip_relocation, monterey:       "4276df4fd4bac988c8cabd2c14da4ec77361b80415c71fc2474363ccb30a9117"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b4552cf9393dc457aef51019bc4187718b6e1e621dcd615c85c8f9e526ab685"
    sha256 cellar: :any_skip_relocation, catalina:       "b16d15d659840b46f8e9524266f79beefaba6509c3eceecd45c15fc8f9df44ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57ef4f68ec2ef78ad354f5d3750d5fbdb1b14cc4674e316a622e98074fba213"
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
