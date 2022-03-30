class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.16",
      revision: "fbb376b431a2614be063d8a3b21b73ad01d53324"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69a913e246696d23c4027f5b2cf8d8570fbbf3afb87797537b8d16e14ec7eeb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "335f6b0d545850efcc0276e8397cb42d7080704d8380d7f9b073b0e64ebcf4bd"
    sha256 cellar: :any_skip_relocation, monterey:       "c8886f18683a14c23d873dda854505e4eedfc331ef0e19a0227ba2f8b415ecf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c6a722c2a9178654e23398b67c28b1fbf3aa1eb530f4ce631f19d22b74a443e"
    sha256 cellar: :any_skip_relocation, catalina:       "c683b84c13c2ecdb24ece53e906c0c3a8725524eac27a95e0a9c9b31e00931fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad7ef496dd5504066bd50ac0f90e54ef611904368fd420ec68d209a4d037e001"
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
