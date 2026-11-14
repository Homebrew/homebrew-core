class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.2.5",
        revision: "46f5839ce154cbb430a2076602025c08985517f4"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bf023fa034330f2301c16bbef289b1a7bed91b1fac2dab8252cf7ec529574a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e894ec1e72fdd5bf004eb6ad5d3872610635ba12f583901fd6eb14867c6eb37e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b1e551446fd985975aa799fa594751c01df26bee06470f391c8e5ecaa0c75cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c94ae591c8bb0c4a4878a4a5180afb27d220e41e6333281fc5f5523eb124e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2ea25aa265f3b129e6542084e90ce4668aa81be3a60c6bf9fc95d391a1ef4cbf"
  end

  depends_on "go" => :build

  deny_network_access!

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
