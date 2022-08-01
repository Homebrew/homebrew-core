class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.25",
      revision: "10990ae66d1ebb945046d97e14e89acf267a7d2a"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db51b9a44b8bb290fa92332854bde105f91b3cb83d3dcc97717997b5eb385035"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f4ef3c44e39dec06e916ff911c838e2ef1165006e287da642c3acfd193baf2"
    sha256 cellar: :any_skip_relocation, monterey:       "4bab2574aa27d2cbcba928b76bbe8e12f32d49965e728f8ca5ea81944516bf47"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccce1c71105efb39aec3823e1ae76a0c400bc92396b38ae9a0c90445cc27d70c"
    sha256 cellar: :any_skip_relocation, catalina:       "61fdcc8481cb7cbea5f1e7b8d4465e79f5492d930ed50c4acc8ffa6008ddc9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcb531d3633a39d34a0ef693505fadcabcb179535961e1cc4f063f47e51cefc3"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
