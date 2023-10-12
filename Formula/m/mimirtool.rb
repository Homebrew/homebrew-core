class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.10.1",
        revision: "a66c9dd212b09d9197c74da78a2d8263d881f482"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7978c57b0b9ef51eca74a54869b5105d0faa5b44044075102b41d3dac683e4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22be8e709e21741db11e22201cb31657a6988ef3d2ac96ca516e307835673e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b8859c01c45aa11433be339b4d08e9d47a9221b8b6882fa8d256a56fa336fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "f874786b1916bc88383f59dc5ce839a343ff275f6092e01162ae8e67aa5e408b"
    sha256 cellar: :any_skip_relocation, ventura:        "21799a54ec5ef6c9f9c46b2973daef2e715cbc45d22bc5c3d6cd7ca4f6df179c"
    sha256 cellar: :any_skip_relocation, monterey:       "38f327cabeccd48695e7ed033525a48ca0e87752627777320fd1b9d9d4108089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5017a8f44247cf7a7ecd55436d54e02858ccdbdbd1e35d63a317c56a91c507f4"
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
