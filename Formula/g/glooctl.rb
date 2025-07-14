class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.19.3",
      revision: "cb104708fc02e535161f949692f3fb7d56277d26"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d90e819ecfc8da0a53040ef151909c8b602a22528f461486664846b6e6991ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "986eaa1386ebac4edce4f038b45811ae1384d34ba77600ef0c0dbc8fd56bb3b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2292385caeb9352b58ffea1153ebd94922b10b3eede4cb1561e0af9596cfe2ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "73022b208344cdea8294498997e75fcf3a91807199c59dfb1b8e0fccc44210b3"
    sha256 cellar: :any_skip_relocation, ventura:       "41794e44beae3d2eac0f0a6236f8df485094cbd3b4a61cf9f7ff6880f6d7e25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "129b1a5bbaeda6501423e685082e5c51ca7253f8fab78f577979666415dd5fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5bcfecff113721405080097fa7cd306b35c7fdd683f030399f166687f549c56"
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
