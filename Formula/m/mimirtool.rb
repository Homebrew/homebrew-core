class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.10.2",
        revision: "e0ed0f5986389fe5357bc6cba8589b5a1fc5ff3a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22de99840c5e8cab3980d5a3aa4838b7840764c9118184fade19963d4d780cd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d02dca00a1b5e1e4fad7be338f10123a03e017940f52815835613719a904abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce052d60901272b8f463299ea756ce5888a00670aa0b6dc75fc91e0d2ab0ceec"
    sha256 cellar: :any_skip_relocation, sonoma:         "c10b6e9ec8767fd76b07263095a6562a8d3c2e3ebd806b3f468a49ec720ad8b4"
    sha256 cellar: :any_skip_relocation, ventura:        "c1095f48683125f89e60e30e7ed8f59c37ca6f9bdf2a58653126bf65e27e3c13"
    sha256 cellar: :any_skip_relocation, monterey:       "593262b6bb954d39ee6591e2ba8ce0d53d2b2829d041a6a546d936a12f3401ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea0033ad0970130edbf39613ba3ed985e760ae498ab7d570c69937dd1cd3149"
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
    test_rule = <<~EOF
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    EOF

    (testpath/"rule.yaml").write(test_rule)

    output = shell_output("#{bin}/mimirtool rules check #{testpath / "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end
