class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "a55b758d4c1a2637037093fe815b1063159f11285f07aeeca57ad76bf7e16cb5"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3024c38e6b50df98166540dacf34a49d7a46d0373c36221e205cfe998b382f58"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3024c38e6b50df98166540dacf34a49d7a46d0373c36221e205cfe998b382f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3024c38e6b50df98166540dacf34a49d7a46d0373c36221e205cfe998b382f58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "111c0a9f5de13e01609d1f035eba2a2736648442cf28146b3f21dd89ebd36f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4104b6164d509b62fbae9b977065e39c35b5a1158cea4a392a191069690eb2fb"
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
