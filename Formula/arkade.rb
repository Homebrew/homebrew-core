class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.26",
      revision: "613830dba8a5a8a529ce9ff2390b054b20fa6929"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa495083d2ef6db19ff66adf6cd3b5721127570557779bbb61c117e9df4441f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41d67dde296c41e5c8ae9c1204c0c8a85aa186f788c12662ca55f7a9b43e4e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "aa6a5d6b3a10b1362598d81a7c6597c93f0d4252b4ce3bc34d495415276cfa3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b33d431a9f2fad9f6b3710a9bf6f859a01c65a6f661b4d29aa0675f9f0cc7831"
    sha256 cellar: :any_skip_relocation, catalina:       "4d37cc53a2667908440d976dc4721608bcc6a01bb67376b53c09ab254a7b1829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4409c671f4ceff2ca6a015bd5d97e13d8de035f4b654aaff8051dd475899980"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    (zsh_completion/"_arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "zsh")
    (bash_completion/"arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "bash")
    (fish_completion/"arkade.fish").write Utils.safe_popen_read(bin/"arkade", "completion", "fish")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef _arkade arkade", "#compdef _arkade arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
