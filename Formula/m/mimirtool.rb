class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.0.3",
        revision: "0b00ebf5d3766c766d319a8c23cd165f5c60a5e5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7263833f43e202a900885ec203720da22a9dc0c76ba74086357b6c9000a8c997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6642d6d6db82c3f884209d22585a69fb8c59f3ef09f40b0395a02f6f30b66317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd91d21e9ca7212a716f6c4781eb0cb5e2d1c41dd5efdd10c6eadad7cd2283f"
    sha256 cellar: :any_skip_relocation, sonoma:        "385f6a0aa742bdc421c381f68f5a35658c70370e000ab2db83626eb2df57ecb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99f799f1f2d8fe1016acf80ac180f5f332713f2c4dcde9868e9f4b34bb353bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90552d6e7f6b5edea69fc3eda319090f528e8522d159be4105f1819b4394f4c8"
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
