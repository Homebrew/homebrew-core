class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.2.0",
        revision: "9ab70ccf850c7f9cf06ccc42e28faf8d5bdaa70f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff8fad79ee500894c455d65f6793e231c81e6e5397355774238ad7d9aba56c60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b8eaa76a04e9d5e5da048362f0002c8b5c4d96738f3a2cf8da3f13a836c9e13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a203fbb0b3a99a7b3f7c2fa18edb329b38d5004d55ef8044670830dcc55d475e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a2f26a36668afc83ad0375e2284ec2c7f53efc637dddb018017f004697a0b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d446172069428227deb675b5a2c41544e2befb08ac1cae564165d66c44384af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38185002275d067196f67607732b55be6a784b536d917e9e2cfb1108d430b68c"
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
