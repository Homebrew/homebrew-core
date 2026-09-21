class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.2.1",
        revision: "e49585d43c6e852225e114bd1ddd98da58a4c060"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "419dd71a41e4297dd6c2430df2c7d53697312d58edea5162cf2cdad95e27c5fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df375f3fdc0c31bc53876e430a8873d4d1ae4046b433baa1a4b2e12a5a2f298c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9cf9efabd55c2a689f9677384c1a70932920c6b80cef9e14dee7735345523b74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7b2e0b79f0cdd46b9d258bc83d5d2d7d1cf52888101f259d8fdd0300e80ef6ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e5d10667164a29f8a71c70e534064064f41eb1fe4898baf5f9a31fd605865ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "103032f8774e32c33b072fe53cb1e701ee1cf2b1277b84134d2d4e990d3fd18e"
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
