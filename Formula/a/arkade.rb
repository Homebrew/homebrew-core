class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.9",
      revision: "0818507bbdc296410f6dbafd249e28c722c07a38"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e0081094222ae4d5b259e2c6f91cbd43584f257f58908c3e0e912b70f2fddef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c47cdc48021765e4e2e4a295ad17b26da30d0d8c056c2eb796fb1dbc07f14de9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa420db03ea2e238a57e74b6ad8bb01a050f3abf97d32d0342d3a0499faf221"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ce6f052c693045addc9e6b928cfdec2cea20af69fe38a5c84d8e53b3a39328c"
    sha256 cellar: :any_skip_relocation, ventura:        "89fad7a02171b325c23bd9f3ea96e6d0f9faabfceeafe0fa08a650bf2b5cc2f0"
    sha256 cellar: :any_skip_relocation, monterey:       "a56b76c9432887026bfe953f1d337b95607358f45611d295425dc21b9323afb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75a01ad02d0f2a27ce3646b1ff4219b72c52a813295667de9ec83a8215e1a67"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
