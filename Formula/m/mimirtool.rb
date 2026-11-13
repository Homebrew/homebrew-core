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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c2f4fe6a5729b75a5b6955198a9423364f0de43d74a4394a3a88c78680b6bc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8da966cc6732f0c96b827134a5559f193b44c3f6ed2f70081534dbb409d3b98b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3460f29986544889d36634ff8c92af75e91fb8a2045e1017546028416e0bb08"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "042eb10d42dea5a1406bce470bb196a25d1f8fa1e41ff135a9a48db8a1e89663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bdf93a061ed43b2ba6f37d39200621a622d97592875592d29f9ab716450e1063"
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
