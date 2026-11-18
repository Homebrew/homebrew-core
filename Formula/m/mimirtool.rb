class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.2.6",
        revision: "634964f9567675883abf003393e9cd1cafcc584e"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8474b35f2b429d64764413383511b15610a285a4037f4513c1191e45e501c6cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b5e8e50919379124d8160bb529701c5ce7e8e9bfc5b0b42ca039937223765a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e1fd33a499c2afd439e00eacea7a401b0f38365e9767c599093aea0c2839e74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6929cf5b3cd430ba6ae140acd057bd29ab49d461d2136fd34145a22042b564ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3c5de01d1f3f7ef4d4c709db17b43e5897fe31fce34c37eb8a9b6eac65059b2f"
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
