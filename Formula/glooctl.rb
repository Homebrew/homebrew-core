class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.8",
      revision: "41be40b683591fb419849df98a5cacb9eaa42aca"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b13059b42549062cad83ac4a00f74c7aef413451975d48abdf50b36a8c41707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d87882c347640fb1076129e9f1f4a8ff831369f6d3608ca39bf99807c79b935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4c18c6835a3af31c0baae1f7dafcaafd0335bc9af812beb445c6463d22e0133"
    sha256 cellar: :any_skip_relocation, ventura:        "f1e55421742829790bb9a713db6779052149ba28d031ab3c038cccbcc449f532"
    sha256 cellar: :any_skip_relocation, monterey:       "b3eae6429ced96ebac633def5eeaab09ce7a9d7d0f25941eab09301531cc4361"
    sha256 cellar: :any_skip_relocation, big_sur:        "2921666511bf24c058dcb6ec27570e49b55142180ae4bb4347770c851a925ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e4dd35a3d9141ca52f94c373d7af5a6f934384ceef839d6077efbfc6f1d40e0"
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
