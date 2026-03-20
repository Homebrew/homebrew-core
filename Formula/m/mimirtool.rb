class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.0.4",
        revision: "75e092c1108cdea06e21fe488282bafbb38daf34"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ecac5a15a8e02ec4d2cb70d6e9a555a4a6522c9f4ddd946a7c4989b23c2af73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6ed353e347857716721850d7bf77c65422b6fe24983c514be017d8e6ea707ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f412a626294a3985da8276d3b09b86b20c7e0d051fe404be06594b94e336854"
    sha256 cellar: :any_skip_relocation, sonoma:        "76f48e12625e242825ded71f87c8fbcf194f377ea8022eef47ebe623075b7fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c8cc78d7035a82751145a007f08f21fa90409768f90f705f9d4b9aebe8fb4b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c79bf9a2cb623000e7c423dfd28198f0fc4525714afc9505ba6fe91a9dd17ee"
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
