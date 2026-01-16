class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.20.9.tar.gz"
  sha256 "343639c893a85ace9c54d8781f793c534e96ad6ebdf34800f1f8501391cb0dd0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bda003555ccc787fdd2ab5fae1941f977df2348b99e901a5c63030d8f1d5db26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308ca68a7d3e52aebf75bd3b160e4112d4893b83b10f6c7b8b40d30e8127af11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d0ee114fa89c968414207b86ee0ff2beb5d0f9e3261867e150c96a4d80c688"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcb4db1fab794ce26144744a73a68b5d6ac8aa736c5e7a113c30b8ac854e1b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35347ac68aac604c4670e1d6fc89801f716a9785556723e43782e8d5ef938d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0add007b8b57fcfcde00697a5e0a4ee66660f29e77aba9f6957944b1675e8efb"
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
