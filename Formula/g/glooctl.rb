class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "6ccce7a32746e2ed19f197526107e3096bf20b1b8589cef26435461d30afb739"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdb22a1391da3cf6acdd69b5b0d0e3a19312ac2764641e15c5dd86f70d725cd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eebfbaf1a68915c9838b13188905d62b91bb2ba93f53a5e21b63f6fe312c7f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e3be2185fa497aa829d140eced7a376fbe3fe103ab76fb91bf46bef1d52184"
    sha256 cellar: :any_skip_relocation, sonoma:        "68eb4f1fdad3f2af577c98448772f4f0aed7f0454086e04a29b3eb22997a4ac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c23f833305e24867ef3ee961077e69a303099de19860cb3ed4d5242bad78f03f"
    sha256 cellar: :any,                 x86_64_linux:  "c2b9489e7f45a58316995a1cf515f26584eee8e0d208a49a10a752b9d267d799"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

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
