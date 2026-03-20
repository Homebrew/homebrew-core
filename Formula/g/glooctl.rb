class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.20.12.tar.gz"
  sha256 "7ab9c31d957931dcce1845ce085baa2a0d07429c7dff8febfebac01e6c03a21a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0274048fd489eb035c6fcb01c3564cc9760127eff7b940eff27070f7c747a972"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fe2e5a7c480f731f2bd715a64e71fd6e20fd2517dc86bdefba87bae92178e6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58fdb69d2c391a72ee77a4e4e07e7e539b4852f95d7b64a4b49d2450b80295fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0a10de6f21f03158fdab199c30a0f1ec7910756f3bebedc30620ae28955c19b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef0c0808417308970187fd3c47f95fcf7937cd35830d230bbfcdae0d834943a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b111749b96e30783a6ea6b629a63fb8b7d91fc02cd57f911908e5a871400f844"
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
