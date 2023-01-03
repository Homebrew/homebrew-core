class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.54",
      revision: "032001c3b18f9acb92bc5bf133f03718b8d5cc98"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30e817f3c58120181e2f87ba75f11c0acebe822fa53740014e4d0495f599f46a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "134e8daea2920491d557c04ae6ebf996a40449906e66eccc3ead00e7d2062e21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e90e209f3bff5155576315bb3e357443cc448d3cedc0089c67dfb880a211528"
    sha256 cellar: :any_skip_relocation, ventura:        "025ec82c976638cb359be5735e6ce96580ba664d42fec2bc3664d58c1cf46de1"
    sha256 cellar: :any_skip_relocation, monterey:       "78321ef8d2e12ffaa7daf767cdeedd33e51f5702af92a9162a221361f00b883a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1f26d4164c80362f1381b9c7c0ee1908197ffb7f6a5666326b96c219f87f9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74e46e506ef608f539552b883cd9c8726c7bacee29fec1489552e63b27372896"
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

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
