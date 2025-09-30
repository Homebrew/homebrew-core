class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.17.1",
        revision: "c5ebb8f3e8de7b8c0c429152c2109db0be4f3ab4"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(/^mimir[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bed8eeb51e44f29eaa5fb77c205663eabceec18c6de4b6f04234a4b94dcb0e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28297acb0eb932b2a6b1a2ba85bff2647de0ff6e7db7a11d0f0fbf5351fa040c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5aa8ebb3eea3c2525f0513b15f8d3e476babdb8cc6abc7d196e85983f154fc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82db42c65cd64954d414e2d8d729b946204d22bb9887e131d6903acfd8227616"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cf2206016d3762e6d9c9ef0e18486adaec4f3d5c9493348f388ca8f5a8af58e"
    sha256 cellar: :any_skip_relocation, ventura:       "1b40d5656062c526f633273fc41a5f781bf19f70efe8264e4a2717c7015436e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34c2f32837a64e710bf6e7e5345292eceb4cba97ca2a59903ff69cd7098ead60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3315ea787a57b847669cd31a993f1a164cec20de5ecc45c982b4d95a1735193c"
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "GENERATE_FILES=false", "cmd/mimirtool/mimirtool"
    bin.install "cmd/mimirtool/mimirtool"
  end

  test do
    # Check that the version number was correctly embedded in the binary
    assert_match version.to_s, shell_output("#{bin}/mimirtool version")

    # Check that the binary runs as expected by testing the 'rules check' command
    test_rule = <<~YAML
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    YAML

    (testpath/"rule.yaml").write(test_rule)

    output = shell_output("#{bin}/mimirtool rules check #{testpath / "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end
