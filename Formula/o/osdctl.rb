class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "a1ee1cf6910f738fb4e00d0fa7246e1c3de48a19d7fb50972ceb405ac3e705db"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1565b272e73be82cf19c7e35109a8a8d9e06a726584c02abcd8ef21d52411c62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1565b272e73be82cf19c7e35109a8a8d9e06a726584c02abcd8ef21d52411c62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1565b272e73be82cf19c7e35109a8a8d9e06a726584c02abcd8ef21d52411c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c58996f605f2f238e8fa4ee17aace4434c18e368b6363d896d76a2b055ba3ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c6d927fbe3ccf5b73db4493dcae0f9f6f8990cf35f171419eaf0ee18df4c9a54"
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
