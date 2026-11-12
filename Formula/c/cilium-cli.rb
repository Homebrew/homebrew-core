class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "bbb768efce3591d6f701b47dee9140dc4945c055e3626c98cfa670878e1c62e6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "158cd6c2a5391eeb551381d7861303a15270717d2478b1549e139b9c522396dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9e84392e4df584545e522886d5c9d52e9995f494cc4caa57bfd93b440275fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3db0341bc0b1f34c52bfcdf0ca7f025af2921d27fb0c927574af62b0d4b62bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab36834d3902041a19549d63ae4e8c909ef6575aeab2e6c226a6ed1be48e80ce"
    sha256 cellar: :any,                 x86_64_linux:      "60369011c121fe80dca6f66acd849551237113cd6dde9f082bfd31e856acb2f0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
