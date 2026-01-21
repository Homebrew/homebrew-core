class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.0.2",
        revision: "b07d6f901b58337e4a7d2cd69c1549deadf3651e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8502164f7fb2f5b03f574e6588dd1f98bb75ed0b52fe196e60827a83fea92fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36b4bbc6c83e47321280f237b0ae3ec6cb2dded5cd51a40eba3110f8da4567ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637655c35c87739e92a3703d9384dd096105015e31b950e6ca9f2b8a281948e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c013b33f5c9386cab95bb27e965ae49317cc30823cf2d05183515c99398dddf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e57cde705add7c97c6228eee2bdcf298fe872f30bf1da6d51cfc01308cf61194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6414b8d13fac7d5abc32f1d203498a62a57a7349e8db137036bee4a7e0e1ff12"
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
