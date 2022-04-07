class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.22",
      revision: "2d3df2c8eb2ea261aee0f13bf6c7550a5c41750c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b9322e2b545611564aec874b456bf3b7c8ee5bf3d6652ef9126d710f69f612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ce0f99759fec3a48a01044a0b8a861c472760e43bcbd45e22b0ea2caf05b95e"
    sha256 cellar: :any_skip_relocation, monterey:       "21d402eb6409bf0ec3a79fcabf1a9e0d86574f1d0e7f8182c231f7cde75888a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "744e2f126275d809827a92ae837488a8335ccb03b8c4427c93e705ca15a4bd5b"
    sha256 cellar: :any_skip_relocation, catalina:       "cd37684030c83bb6dac6f5ea98aa1ac5ebb89d22d4cb32e247a808d1ea4c565c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cea0ffd0b50b7a1274b4d855d0130526f9e9c4f0a22af8411b91a5d7cf9d641"
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
