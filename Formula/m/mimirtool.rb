class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.11.0",
        revision: "c8939ea55f0818337e3428924f25dafc6ea256d1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00df3f5aedbdc5b0a73f781227642a421bdddfd0d423f62805a3751fe4461d13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96f79e03f30a5a4fa2794592f9f72488003393380fc3eb5ad54eb509b23427f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a737b9138cb31ae0afb23a33b9c033a5febb911dc82892d5d8253e4eb37ab63d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ce18734a26b07bfe8351d4d5b0182d7a92b56c4181c805beebebb623346212d"
    sha256 cellar: :any_skip_relocation, ventura:        "dd840250b2aef84f93c1a0cfbd4f4bb346e6117023c6f357eee1f918a188b6b7"
    sha256 cellar: :any_skip_relocation, monterey:       "0c45e69caa0b2192aa14834147f08700735ef64b675e31854da43b3bdf576495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0443531a6cb2438e163e542cbe2f2d45f0740bef2570d683a0d9aae8c88307e"
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
