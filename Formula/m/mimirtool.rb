class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.17.2",
        revision: "bce93699bd2d5b8fc530034073be7d2da4365751"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d7aef7b8f7bdad68830cf9ab614e04724dd693455d6d95b3bfb2523a34901c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22d1df6ab540e620d7cad335614db51374d2fb7da86f4feea6a80ef5e14ef367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e083bd12e7ff18e382a92426ba43e54bfd45034cc1b659ed483db80fff411d62"
    sha256 cellar: :any_skip_relocation, sonoma:        "a46d2a9e55bb5414360d2a83c38649486973062149de9e44769cc96de8d86db2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6457758e7972581895cc931437b98f576a7bb332a965e49319aca6b6540d5c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f425060afd08e8eb9c738b4a671c0d4a3d325ac0cb640efc428451926dfd2be6"
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
