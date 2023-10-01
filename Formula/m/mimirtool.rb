class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.10.0",
        revision: "77906f76055188998b0f8f28b89aaeb68ab08feb"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6e33c76a57d5d983e531ebabca14da511adf220c19088346cdce81e98f09170"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ced50946a1b8e0d3776f1eade1b70f4f431436751e68701d40f4bfde4c43468a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9b3a0adcb055d18c86a69282309298da69f8fd3c2e338ef97cea99f9493c5da"
    sha256 cellar: :any_skip_relocation, ventura:        "25a334a3e176f430ea92535cb1df8e4152126f1d6aadf923cf819e9c4c955f0b"
    sha256 cellar: :any_skip_relocation, monterey:       "a94c79658c154413cf0a1e9b354cdc8a1f9a8974e7d71016bc89fe242f91f7a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "92ce328b87e26ba8099b7823d4632ebc67fc5a4f3d641d4f368c01f1c4a24e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd0080c5888d73a88817c861a0ed5430a7f52ea454c66db2441c2079f69ec15"
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
