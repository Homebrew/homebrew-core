class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.14.0",
        revision: "bc5a6ce2f67de0f5fbade9b000e4bf46d6d59518"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "772bc3ad5a4b700aa420e409e8152a0c99b8d07e5b8062f1861ed52d80e2d3f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b4677a015f7761cc4f992fea1dd41febc3e87bbde642ba9ac893edc60763209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8945e68dca18ab470d3f7925cea5b96b38c350a88bc0e73043e6e24acfbde098"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fb7a0eef2d0f3a56c2fefcdb4184adb60cf7459174e112fc443f0f5f8c88939"
    sha256 cellar: :any_skip_relocation, ventura:       "ec15a22a4e42b444d0b87a7c6d9927b8522242e2d7551dcf8494b246503a9a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad84a06e157e494a8311b2c6727a88fc97ce5fa117a6ec0bf5061f8432b6f03"
  end

  # use "go" again after https://github.com/grafana/mimir/issues/9033 is fixed and released
  depends_on "go@1.22" => :build

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
