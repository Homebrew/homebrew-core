class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.0.6",
        revision: "25026e726c2add35575740d9732804c61bc70f73"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbed1ed905503687e4d11c856ba3120fb987fd163df874b5308228fedf2d9792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "671b3698e7686775aa106b41d3a44014f81e62ff6d365fd07f247da55387d863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f62c1eb5bdfd0caef7853f84f932ec3fdcc206a6592214f81bafcff1ef33d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ac81153196c7cba37e4be04a7dfda78dce0dc87f2dd64f24cbc20ee0214ecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92d7c86b6cb8ce3ac38d580c5f616208bb9cba41b39f41fad982ad8d714283e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f212d853fad97940245cbfc9da6bb82047dc49623e59d3f3ec91a2f9c5a1f82"
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
