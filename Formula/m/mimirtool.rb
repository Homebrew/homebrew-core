class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.15.0",
        revision: "24e4281c138d873772076c5ac276a0f20f633d0d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046b37b66986207773688c77710e658845580d0dd2543dc638592533024ba503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1df096d6cea6d5a52255b13ec1bf6324a9c920a16af48d7962c6403333c6c8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dd7cc35a7a011cf2f3f60bed0686cd6f3bcf052faa9ab49da8bc98f82485593"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7653c2142e53044844df5cf645e0f6536007c5d08865f220de37cdaa9c81d6"
    sha256 cellar: :any_skip_relocation, ventura:       "f211afc6e8718f63910f20b637c169fe7a0ac5618cab11e9604f391f15495346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2b657dc537a4b4261f691a79c3c1366e4d8445d0966c21ea29bb9bd38cef80"
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
