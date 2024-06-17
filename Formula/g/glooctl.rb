class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.15",
      revision: "994fa6fdaf0f148bc13116c0ae065f63745ea03e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de2933e0cc03bec76c04f86c731f737b4c4971bcf153a260e9fba0c123b7801f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da065e38d14c072408e779743de9c585d206debdfbd0ab40b13efa59b4d31247"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e89ea9906b13d1a427939e5769d50ce1c0ecc4df681a29e15ee9ddd3c4af7912"
    sha256 cellar: :any_skip_relocation, sonoma:         "e78506b69b5598f1d2c58957fff611f9dccff171f1a587f4262761fb0ce80120"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba89fa1528238260d6c702a98093bb421ff3f065d8539073e9dfa393835d137"
    sha256 cellar: :any_skip_relocation, monterey:       "01a1766c933d820abefa8f4f379405ce54dfefd3745bba4b2da2386aa73188b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "139b03d785b8b70590e0a367fbbf8a93a3d2aa57cbde869915b53d0897be4e41"
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
