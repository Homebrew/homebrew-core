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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16ddb3115382631494d93f21bd14128f2215264ab8738cd19d23928929c0a06a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "813cd825372b5aa2d636ca77b23c90bbbe6ef4843bc5e4e3c67af646c235d679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad3c42001808f207eb0ecf0224c4d93835320a445a46711d31614d7bed4ff898"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85859cca0c06e86c9a6db509f3945512252f2988fea45ac591e4afacc0ff4bc0"
    sha256 cellar: :any,                 x86_64_linux:      "1c01baa1533440e2b345103b89b2983d8c89f618377a2de39e5414bcd15d4663"
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
