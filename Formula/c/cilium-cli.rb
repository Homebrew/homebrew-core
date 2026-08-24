class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "3bb9a91bbbede233cc5929208c6de1366b0d5df99a9d65728121589f7b1b81cf"
  license "Apache-2.0"
  head "https://github.com/cilium/cilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c8742178912239dde8391394d833f0863acabe7a6eb49ece53273978b4f6e66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8afb753e4f32cc8d3f7dbc45b571f3757f42bd4c29358343e104d22a116a0235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e28d8446bc3e02fb4c9273c8d4520930cb0768693c114894b6bc10d84350dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1b13f8bcf10287760ff3f898829045617bda24202fd3c64a8d57d3c4d03cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcad62b1906192d80096ad844603dd60ec9d0c8cce8a3e51f70b685e13aa9e5a"
    sha256 cellar: :any,                 x86_64_linux:  "0a7cb4abd8fca19879ff432db036c0bd88a9b48a4844da60fda764647b707e6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", shell_parameter_format: :cobra)
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
