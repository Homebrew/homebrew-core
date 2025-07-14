class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.16.1",
        revision: "876d470fb15f9504a4016a0b60aa2ad4d1ba9a0a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b679976666bd6b73e4481decafa95c4471ea3a7414920c5f45d6a86b5f8be99b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad1073266d969aac8c87136cf7ce503d50dd82637969d39a2ac8be030ce0efdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f0c89e74f2b3adb0aeffb966203467095b766e94ed32ab70a7b7b32f6235f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed42a3b27cdaf1fb58dd111bc20f94e16f9b3dab1face15ed9867afe603c5d2e"
    sha256 cellar: :any_skip_relocation, ventura:       "8865ddf2f771ec27bec39a86be060801516f236796e9455cacbfbd09e6570d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f686a182c3e37468e1a03be9dba877fe21d7aed3dd3aa78640cb0c603fdda45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d2259917a65d67df9e2230928be1d06fd77b5855e4891576fa227757b723e2"
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
