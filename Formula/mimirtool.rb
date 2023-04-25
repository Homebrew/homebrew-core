class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.7.2",
        revision: "76a1021a17da0e4cc26f48903e06e6cbf622067a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c0213d0dc0a55484a1c040fdef9bc4055ea6e70316cf4f3f9843b96bf3ced0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0588a6043e9c9d7a619231cb5f53d62da7f26284c7ec502efb31baf5d6cb5176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2488ebdb5825f77ebaa59d9344a002261274f4f7dbc0d53d9cfa6462f0db5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "049ce1e4c4165cad8ab33d95c2ef3d6e1d84e665376a0a8ca39386cf4a77f1ca"
    sha256 cellar: :any_skip_relocation, monterey:       "f4df81fc21a2a49bc88110807bd49ab83264e1c536a3ec7c3771abed10398148"
    sha256 cellar: :any_skip_relocation, big_sur:        "997b1597d4071752e62243d94188c11069933c371bd61499a76c2e9dc2f5776e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5eaa413e2e2bf752b3e502ee71465ecb10b2cdcecdca4484f9f46375be69b3"
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
