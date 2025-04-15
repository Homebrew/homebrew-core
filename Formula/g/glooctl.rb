class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.18.15",
      revision: "1ffc16539fe0dcf3106583e5bfca5da1b7e42edc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "decbe36356b5c5cdf01d52311167571e933de3630cbbfb61223311f08bdff49e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2170b0f50a5f0f2cddc4185cf6a7f9c94da03b1758d62726b36ecc33c0b5cc60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2a18f2f6fc4778626aaebd927583a14a31b01f6c53d6a08e5678bd060dda29b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9198f980b6debd31b23a2351f3fd6f94848cd81713a8e84a121bb84e430b861f"
    sha256 cellar: :any_skip_relocation, ventura:       "b2ecf13d33d5df68bda15153b7036b8523ac95819f86a3f303e6e8e790166218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60bbc0ca37c0507608499f5dbf028d475194c377318074aef77d048b737bc479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c8d128a361133ca9fbf79556e555eacb5b9d6fb8fbc50e01d2492b99929d60"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
