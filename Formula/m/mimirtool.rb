class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.13.0",
        revision: "4775ec156855ba1eb498e564f09abad35053a44f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42f2396e85628e925fb8c4b85139e2eefb48098d1033b48bebcc84f41299718d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e687ecd64eb4bd6e96a51f346dfe9b4d5f3c32f8dc103a4217392ad611c5a3ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04eccdf0d86f5542a09d161b0131d39620d5e046be8f8f007b395dfc9b0da119"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c11711a318ae7785eae435d754456ea4393e8b17b9a35e2970324c1882af05b"
    sha256 cellar: :any_skip_relocation, ventura:        "703a71770894c0c6b94a748f8cef0064a1b5c46c47cc5b2c90f6c0e2db10a57f"
    sha256 cellar: :any_skip_relocation, monterey:       "4a39332303a17db3d6974ce817feaea3effe4fdfa9cd81186b28132bf078c702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4c4acf4e18e856ea816e8b4c01e2b7af0a29eb263e5c04b2e636f83e120f955"
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
