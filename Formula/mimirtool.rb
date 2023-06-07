class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.8.0",
        revision: "f917e084d4a5596565b5debd659db0d4a5f9da6d"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7490475905efb5d56eeb64ac57355c7fea428f9b79d5e72eecdd0446de67a88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "375bcf674a1a30be888f2e3d0d2592330ea2834b906acf6707ec552e6f04e6d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a06e7e3b329edd588eb976dd875bd2d2fbdddeda21282a49789d24ee3975310"
    sha256 cellar: :any_skip_relocation, ventura:        "d7358a5b6560fcc53188aa701232556c2774e1836e33f3c006462b4b5ecb9acc"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6048418b7f7a8a50be58c91321737166b9cc91c60feb8c9c93d5e76478c980"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0802920063e7bca8ecad5b0ae8e5fbf1f5c9f9d7a4c0ca28e8d48d7051711d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8cba946f28d76843b121fc357d82fae1f58f473c4bbb0b9f2fdf61842a42e99"
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
