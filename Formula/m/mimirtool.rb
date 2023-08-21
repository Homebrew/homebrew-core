class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.9.0",
        revision: "761114d8b026dac77ea94517fd9773632c32b42b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ca8a4f59f6aba351ee1dc0884fd0461d48ab1716365aeb390671b636ca8c9e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b153804b26794a39d9a08f6d49d59ec6c72b23f6c48840ae84fad4bb9bc771"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "288fb6de4aa59bc99fe9e414432305f2858043b3424a6e6a44946aef6a1024b1"
    sha256 cellar: :any_skip_relocation, ventura:        "37698cb66a57599a75be2b252c01a4aee0a18fe9391d7a85359e1d5ad2d80780"
    sha256 cellar: :any_skip_relocation, monterey:       "065e4da35b22070882a32d4fe0f08004d8916837e752b4a12c4ea2658ad8c212"
    sha256 cellar: :any_skip_relocation, big_sur:        "acc00eebda763cc12b45775e3e017ae9195690c51d890721c1bbe2e5b969a2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff92e000aa53489ec4a71257e3c0e61731fd8c93af948c88cc633b94e39da983"
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
