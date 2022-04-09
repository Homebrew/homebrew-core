class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.2",
      revision: "435c134f3fa21d6f894668be4ac40098d6460188"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db3eb9852d018f80d108f352e207d212babb585bad55cceee8e16870f1c1500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d155546baf5b3290d060b4f0756a8c681e9331cdc2e99cbfcf02212612835e50"
    sha256 cellar: :any_skip_relocation, monterey:       "0505589e9e55ad1f06287e3af66f76a8f65efc308bd64cd789f61f68d5f50d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5796c799ca763ca4884446479a07772a47f3f64763cedaf52a990ce9e85bc2f"
    sha256 cellar: :any_skip_relocation, catalina:       "a7890808c1182c6672a943ed4ee9eb7b50a3372f1f6e5d9ba2572a5c7b6e3295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e6969226152b11ff9e724a86ac14f2a4e5083d93ef5c749465e65094e853654"
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
