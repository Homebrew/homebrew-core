class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.9",
      revision: "fb08ee144af426f383e808a57667121f65fddeda"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdc29ec74aaf36f811e49ee8b6f8c762aa672e41301c810c9f0e46369ac4dd4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a3df4342f0fc0554eac22bce7cc3809747a94410e4e44347a63869d6d6fe90a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "833769343e71d683f10621144ceac648de039dce39054ebc85440885338e6c2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a317fbe85bd63621ca26ba116c8467064c145d4150abd2aa10206518fd0a8832"
    sha256 cellar: :any_skip_relocation, ventura:        "3ccebe4ae7341ee6beadd560e4a1c60292d900758f16dd24b4b444ebaf688c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "31ede86729bb875cd60cd431719c8ad2b7142e8dab083de50fb121aa8a13b0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41aabb86a706643f968c98d7ef043071719925102cb0f71e9bdec401c6c90de7"
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
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
