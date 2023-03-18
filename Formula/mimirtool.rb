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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c28559176ef3fa0d8cbcb90c49fc8390020b9a4eea8d11f2d93e28b70ae1e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393cc9c9d87d0b88d9c19d29261501388f9c15433c7b74665a4b74ffa931f25a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc45a6b1452599acb95a57c5f7e3db4ac6e3ba46b610a082e77ea6d7904b2b80"
    sha256 cellar: :any_skip_relocation, ventura:        "ffb2f402035276e3a6bc250e5623546c20533420a0ee76283ede0f4f6462860c"
    sha256 cellar: :any_skip_relocation, monterey:       "f62073720f71fe08f06bcab04631253141b2763856a796c55635da218df56fcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "139335dfe466d7a57b4405aa9b4d4e6a15e1bdc45d60b0354293f11714f52de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f8165dced5452c3ea1268aa53daa42b3602ead55b6067dda8ca74c9ec751ca"
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
