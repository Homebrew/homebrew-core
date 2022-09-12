class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.44",
      revision: "b543e60a68285ce8a147d9b0a6493f573747b8d1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa4e4928144a0528cb6a3bd9c026e0adaa09626b4146aed9edbf627098a42d63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c7b67647c8511706a3956cebfd2f6164e5a974526238bd26eb580532650a8af"
    sha256 cellar: :any_skip_relocation, monterey:       "0eca5fc7d660a959292c710981b45874870916e6782f94e8c1dae052cd45c9d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff3413ccfb0be599343c0a1d6acd65462b5c949d6532df8d64d8347cedfdb290"
    sha256 cellar: :any_skip_relocation, catalina:       "943d1677c62a9c0e0c1e7185520367d12d9ea5a76068b015b218917fa4d53238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bddd9f1e396f9522a3697dfa757fe834337b0813f1e7fb04dac1ea42b46a56a5"
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
