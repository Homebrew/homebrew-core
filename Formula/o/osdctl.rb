class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "2592057c6a6e87e1a72a7a4d6a61902db1669fe47ef4aacfde59e9dc0859a7fc"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f9462a76b063ceb80d4745d1d894ed5b654f71e165bf85eeec663779f5b1d29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f9462a76b063ceb80d4745d1d894ed5b654f71e165bf85eeec663779f5b1d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f9462a76b063ceb80d4745d1d894ed5b654f71e165bf85eeec663779f5b1d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1ed91db2323699c16803ef9113c061b710b0450cfef8173b76211a5a787c8fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "372a87272c82fe01efd29c737987b54c32af6c85c2094b9da531eeff609248d1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end
