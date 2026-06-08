class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.1.0",
        revision: "b3a9d931ee6cf2bfb9ff1c73f39fb636c86803b3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34ca735ea553a61e44062ed6b45361c66a613502b8a866663612ced09ab2556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6c3d43f9b0b080733773761e22176c89098b8edcda13d08d585de33fad95d8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4fbc1614afec6021e285e7b9cdf4568e9ba28a018d061c03a17df9bb9695d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f7b08bac43ff00b11816c469a3f0cc879f804c8b6288bf332c2b803e64fe2bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f135a621f9c3416218628359b0410fa232825ab3c53c53ac964432bc9dc3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb5f9eda4865561f01818cb95379e06213aa409e6ab3cb526ae681deed0429f"
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
