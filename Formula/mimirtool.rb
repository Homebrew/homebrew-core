class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.7.1",
        revision: "dbe4ccd39cb58391e6174441ae11ae25bfebd395"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b9f6a83fd26ec2c006639e6620427c7491863535868593da26013d587f30802"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3803852ba6a757efd04cc676401c3c4fe1e97c8a8c55d43088cc8726ac59da0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75d30627cc7d0a62c528252330a82303d8b9f919b14e0ba3b2ea669452db581a"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc7266f632943a5b6a07d325598bc7be69c536f3b74b6afe431c7d87340de7c"
    sha256 cellar: :any_skip_relocation, monterey:       "9fdfc6a3fb8cc5077f5de67e9fc92c9a2fda9dcb3dbf1630f59a466262e0d0df"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7ce6f8082f31f9bc9ca0310a7b701a05a16689440b40d9af0b27a908d72301e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d84add1f17a9b7f7858f15b80200211891e5c9a4723ff604b38d5e7e8af9ce74"
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
