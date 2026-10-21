class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.2.2",
        revision: "b1fe15c38773edf871267735083e4445fc75c3d0"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e66282d0d95d7a06b8924992b8088337f06db26b2ca496fdc11cecdffcbf7cb9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79c78611c39cfc811052f47f8bdec8879a7b86d3d58e4e9159fb66ea0fade0a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7237635ea08d626817466d8dbb632d378c849fb9ab7c93a188e1b5105e0758d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4aef4a1fa4b4bcbd02d9a44984a9d1affa2ee4f0fcc51e5aeb6fec58dfbdcf2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de19d12402e06aa0d24ea52379fcd5aa9fa6f210b725ff734914260df030bc47"
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
