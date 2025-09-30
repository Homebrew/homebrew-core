class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.20.1",
      revision: "c47a7611d897d485129aa5185d64ce173dc4e9bd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bae69a7acd524e358fdb6fe6ea03792c9ed44886a405bf13d1620b2047692973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6747026014c90cc81a56013046bc314797fe56a3513f050ac0f814162ebeaeda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a394fa14b39659c9745c5efb80a3773fbf8ff39bd3609b67aff4dedf9fef726c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a371c25c963368b95440dc1cad7757cf20769290d34fefd890268eabaab5d3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5dcb8be79135292c092da4f02db3907e7c51531b145656e6e81b7f3af7ee11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed8365544aeb26eb45739d4882a14d38d748089480877539e9ba454d90a1568"
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
