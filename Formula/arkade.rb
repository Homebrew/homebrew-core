class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.28",
      revision: "650ceaa1f922602f55bec71b70fe8f239f2b7b2b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7ddf12ac88c0d9863479be711fdbe7ea4b4a35c5e52272f4a9ecb0ac5d315e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93e1c73fa0e432787fc96f52ec84faf48b5a8dd186800bc3b6c754d7aa89931e"
    sha256 cellar: :any_skip_relocation, monterey:       "c4030b69ff668216875f8a0aa2fc5546293ab55a6dd91dfc310c9e3891cb7eaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9121754cbc2f8e666d9f7dc1472aabe421210b269fc50b35b0a715860e98ceda"
    sha256 cellar: :any_skip_relocation, catalina:       "b366e23ef0486b7bae5cb01c28f7a6caab68c7d48a73a0e00993f1cf43a36f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41518285654275553996ddd9b8639586ae6b9a9b97cb1f678a8ff16196c1043a"
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
