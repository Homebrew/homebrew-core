class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.9",
      revision: "85aea1e3b3a43bd937d0dc75c50f5f4624f9698b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1c9b428a3b077c5ce822889026ce6022a59f9e1a900806e18b197f006e5f2d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc962a1c979ffd2c37b1a55e79acdc2bd5004c2e363033388f42fb7c22cb7de0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de21a5732f9625c2cc537d584761cac3d8ea12c98acef017f69e2bbb02f65d0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "935333d25e4a3b2e3254e40e56317f550c7f6292054925cfd46d8151a4d05a27"
    sha256 cellar: :any_skip_relocation, ventura:        "e0288d1bf1e3d79f713072b0c730ea0c748527482ac73af26579a3e0ed14cc9d"
    sha256 cellar: :any_skip_relocation, monterey:       "40a4433649e6dcdcf5f585566c6722e5bf84a39e693833edaeb9f3c9292200eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b9be7f0cf3e453f04c419fbfe5cba31ffca4694bf1bda4fee89e4bae8bdf6e"
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
