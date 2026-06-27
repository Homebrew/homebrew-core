class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.1.2",
        revision: "e23940eb3a28c3e3f34968aa57d6a189370aa0f7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3e5cb70b80548bcc055854d5ac93f6a53e17e5f895bd8a3b82fb2222e7951ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7581335b76121900cc41c5076b7dae73fd95462a4dc2d3f11e0a4857ec89f375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d4e6be14ffcf1785fbadbe780ce1848c93cb5a6a0d4a0a4a554817562c487ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab5c084617181d50c5f90590da17c1c05316870e9f486ebf22afc54cf99af9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd846b71e886e564a8801cbc528c6b19267bd62c93fd0b719b013302513fd25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3489e2d0f2b85dc7b5768ce0a0aa72da995d19ac6e8aa509e8a2119fd7747289"
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
