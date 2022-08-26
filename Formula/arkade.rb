class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.36",
      revision: "4bd127dff6c2a6331535d70c778186ff6075a1af"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835f609011d7d7a59b989f4115e4d37c6d1cd807da501b0760fdde65d4a3caf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d938e33a8efc66fd361d0eb5c7552dfb7755cd6f52bd501748e1125a33eda12"
    sha256 cellar: :any_skip_relocation, monterey:       "a854b41adfe66dd383fc84eda52888a93d25d84ebad4e8d94a74040205cc6941"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ae3b7bfb59f571c544d6ff89b55a404f5efa952ebd4896c23874ab93e836d8f"
    sha256 cellar: :any_skip_relocation, catalina:       "db4860e58f28571c5583f2433a24a8e2ff189ec5e0d683963992e33d0eff945e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4b274de1f862c1f03c0b825631dde0fb0a909951e5bb6ee6f14b7856f74007"
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
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
