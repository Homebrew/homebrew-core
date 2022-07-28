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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "382a6a437e398a2c8eeaf48c332300b197b7a4e9ddc8094c06be4caf014b916b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0558fea8efa82c566a4fecca963e2257dbea5ce1c252d496c9487e778499190"
    sha256 cellar: :any_skip_relocation, monterey:       "dba25e69c7f6436aab2fc24262a3af8eb1b56dcf584cb162461aa8bce74fe6e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "32aea307b0af446d7a8acae0ad7a9c9e2171c11f83874a26b5249dcb07eaef8d"
    sha256 cellar: :any_skip_relocation, catalina:       "0cd8c4dcae6b529fac0c4600ed0058cfc481f443bc325cc98eccf40fbe7abb4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e419105169cbd1c3449c9b8a042d4615c7fa16cc63c5d0f137380d2b42fede"
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
