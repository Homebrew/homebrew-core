class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.8.tar.gz"
  sha256 "fd4b381c81a253bbd7b64efe5c6e0037f015a4784c023ae057bee3a9b5eec0cd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubReleases` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38b6ce4c4f0bcb0049510d6e9caa2015daab75d415715093fb37b7665f086bfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f13f5f604e6a3018da54aac7067e356dbfaa0421a1e06680e78b22090e4144c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c92ade8d6116f24680fa3a8fbd745f3c17065fc4c628a8fc2f1d6d6a3846a258"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f095585def40a7f433e7cc19bec14e1e0e89a549bceb7eda6f101ef2d1a87e18"
    sha256 cellar: :any,                 x86_64_linux:      "dd20a3082db1a1823fb9a075d7a5438120ecf6b20a237e2a395b10ab136e9781"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "--X github.com/solo-io/gloo/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./projects/gloo/cli/cmd"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", output

    output = shell_output("#{bin}/glooctl version -o table 2>&1")
    assert_match "Client version: #{version}", output
    assert_match "Server: version undefined", output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", output
  end
end
