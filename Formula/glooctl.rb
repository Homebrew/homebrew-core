class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.15",
      revision: "bd20dfcd222fc720cf0a4f9569477fb1bf4a4469"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca43faf7e54b0a149d25d1c803b9a56e2e27eba7136c5f95cfee46cd1e9e97b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ca70fca7c41fcaedde32abc6b2e87c5fe8c11c2d6f31679227faac13a2d8962"
    sha256 cellar: :any_skip_relocation, monterey:       "aeddf009588968eacca410454ba3a6dba9bd31efb1d5bc369714f0cdfee29319"
    sha256 cellar: :any_skip_relocation, big_sur:        "73023be63831171ca191f0a87e5799fdb5123a2ed2a1f68c5f545b2156999bff"
    sha256 cellar: :any_skip_relocation, catalina:       "1f242555e382cea39a1221a47b90f6d81bb1872dc2fadc78ec1f92f7e57af138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f0d76c39ecb34cf87e6359331944786f8fe3fefb9b29b7c198e1284631b280"
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
