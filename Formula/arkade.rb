class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.18",
      revision: "f8a4add41fb0c2141147c52b6485ffbfa93f3aa3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab8581ce42b690d92527e878c97d80a8aaacfb963155e082e389665d14da1ee6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "981b004ed81172939887ef1f0b64537c20919038c57e1c70d6e7b9c852ee9d44"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b538b448d3a8d3abc64ba912690f45c7c99c64356857296f374a7f1b07f565"
    sha256 cellar: :any_skip_relocation, big_sur:        "0afb04491cd3bc117efb526c5f8824de9ade0c62fb7a71d7d77bc88c0bf2d1c9"
    sha256 cellar: :any_skip_relocation, catalina:       "7423982f73c2b92dd42f3b18e5de48b0f322d66b24ef95362a86f82c0bd833c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3fda1e2ce5b74d18e5e7e1e20637bb3300de1b0649df2e565c5e9b86aec21c0"
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
