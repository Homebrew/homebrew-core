class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.16.0",
        revision: "b4f36dac3af7046a0a7a287bb88b503737e07c48"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e5a0931ba134b497468a2f463c2be3aa46b108487571743ea63089288bbafc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41821384aafbb860c72ec59d102d73f64d3ef3056fb253ea3d1207eb26d0a554"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a14c5fe71d7de72a30b98e92c9e3d9f2a7c04b39ab27aa0e7d2156706c827021"
    sha256 cellar: :any_skip_relocation, sonoma:        "8745d740719833ce966e41ff4940acaea9f550e8f7028a1778a0f429dbb90606"
    sha256 cellar: :any_skip_relocation, ventura:       "e455e12db8479fbaf6faa1bf646a1cc4c0df8a092289c39c8a43c749804d7fb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acfac3537d9c5ede709c59a61674f881e7a955fb7e868a35f313d56626463ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5edce97f22531f53937378a98faa840bf774ae3ec048aec8928e0a34be5c3974"
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
