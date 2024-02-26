class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.2",
      revision: "35c1422cff318c142ca8be7365960a623d59ac55"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d811129b19aa5d15f70780e4458ba93f1a9c4e19832c898e61bb628bed55a73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c257355947e9602aec5028abad6c98ce01907517f9bd5d0bdc7101fa542e1615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "543929d2e0b539f08e9dc5b8aeb13833bcf2ef1820c8a4669b366813ca4a1b8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "02910e8d508fb70c1cdf0bf9792cc1f35f551aaaafeb522246fec001f9fdb8bb"
    sha256 cellar: :any_skip_relocation, ventura:        "9da91ad673d98e24fe6b984ec34d055a05c008febaac5b107b1399245cbde9d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9325d0fbbdc747c7fb6c17086112286620b3e36be10802fbd376825a9fd28704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5813ef78b552b1c509cf2571cbda5ebaec58215b52ca1a67e196668034920210"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
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
