class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.14",
      revision: "a548ef23a40a29bfe70ac2d4c749953af30a3cb4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "255b6a05872567e6ed541746bbd5113906692382660867be6d647edd894ded7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "077cfc7eaa4697dd95f94c975e06cefcc1a194311e9bd4d50c31e33b2e33a100"
    sha256 cellar: :any_skip_relocation, catalina:      "1a1cbb97831ee14817bd926ab9b6158181f4da48dfa6f079e07984eb6f50070a"
    sha256 cellar: :any_skip_relocation, mojave:        "146e6b7cf1b705ecd5c8794d4bd1096078306eea2f030eb76dcb5d04fec097e3"
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
