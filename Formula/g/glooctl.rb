class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.4.tar.gz"
  sha256 "cafae822d3ebe18a799925f83a2fd470960ebd2c07c5fb6dca9f20588ec57462"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39ed6de118dd99ca47a17cf9cd03de02301d2ad133cf003b84f38340b568cce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0323ae76dac7d4a07e97e604ff8b40e2077cbe39d32512110a1df150c1e742b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58dc8734357871c98f9174bfb35a3e3a01057dbdf1d85cb983b97778859c913"
    sha256 cellar: :any_skip_relocation, sonoma:        "37806317c34c9e79b7901a5368961318d9dc3ce7d11689e63eeb27de340ed3cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c4765b4ca28e5e48736d5a4bb03e751e891d8ccbcb1310fb8cc4200b8755ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc3c85f4eac2bdaaa2f9e1a426a38a5edee6e367685f9eb7eec1badca72a64cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/solo-io/gloo/pkg/version.Version=#{version}"
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
