class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.10.5",
        revision: "fbecc927058cc19f2d5d1a65e98cfdc76e3ce5c8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c817e111de1f1c0f93916de14a7f55bb4aecc76b72072ab7e97609b5f472454"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e71bf5dc55195b6efa09e4a9353e4adaa1dffd482a50d72d4159fc6c209fc1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "068d03bfee8484731ddaa94302a6a28e9c52d854fcf48e9757753dc0eb3d9639"
    sha256 cellar: :any_skip_relocation, sonoma:         "185ee27f9d9b75c6fc1651aa5f03506860f445b6cd453163ff424aa601e52efe"
    sha256 cellar: :any_skip_relocation, ventura:        "deb79f6befbf58d136e47a4941c599e125b5afb2bcb9be1eb11f404484c758ce"
    sha256 cellar: :any_skip_relocation, monterey:       "0eb95b88408ee0665149d565054d2656827739cc67254f42202873710943c802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd1274a9bb144dd887773b66cd2b19c4d5fce1801f22167457f5927eaf4aa37"
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
