class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.1.4",
        revision: "36ecba9d97d4fbc1f43ac4d21231fbca6f91b4cc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d89a170adf0a57a73742b82b3fde9e87f7fc7917b5448ef241c36452035931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a9b8a33f23168f647246e214ef1e164c9f05c85032ec59d15ef9394fa10971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8562c252d73099f57406b3a13e9253a737d280d2a08f8105710f1f85d48a0ae4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5d43c345c5c05a24242d755aef4c3c97818a9c1061e72507d1b2e5866630e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b57b5665ecac5f6136cd4f5f67d2c2bc089e91519b7517cf1c0aac4eadec168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8987eab22bef6a87259a0de701e70c94bc31834ff8547b6d1564770e5b4250a6"
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
