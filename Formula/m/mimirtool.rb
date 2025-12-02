class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.0.1",
        revision: "ded396d5ac1db5a1d179077fc12cfbdc644d4d1a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd5100c85e33f596a62c89f5b950074b5a16b1d4998d02cbb42556a93a1098b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22a58756664ace5a1c0d10190fa43ec73941fb6f04e853b7c4744255dbeb0605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dce198a78f1025700b4cc0b17de05896b61aa58fbc9c7751779cf22c2c1a2791"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c711ce6f8db42699fe0581ddf2b6dc23ed02e72d7603aa412b2ea2910af5d0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e079908069c56b65cab7209e219faccb44724f4994f82e0250690b3123828b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee36621b54fce18637d08b5cc41c9a971a2e648b9a2d04bcad4c530ad384f14"
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
