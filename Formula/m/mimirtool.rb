class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.12.0",
        revision: "c7aab9e039d63397d2293114ad063b03626e247b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b967360bc0346708e1de7ae249fedf042b7d8d61d769c4eb8ca5d9c354d8f8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37467612c9dcf1d237d9e3be8adac84f4ac15fea111b76bacd8718a2ff682133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f97b9daf7035b922af157612a5d44c01d11056f026dd98d8c67d90fbda7570b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac028623f9e6389ee58301a3af4a4a8d408a89770650c93eef5aa667249e043d"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd9ee652203f30229c3258523623f6eeedeee23d775cb569ed5e1e4240583d1"
    sha256 cellar: :any_skip_relocation, monterey:       "d1090fa72ae73af88133ed42e9b8c9f0eeb10fcbca36e2d7e611d03caa70cd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93fb3820968f5723fd6f472ec23e4a2ae643c78002c5aeed903f75f2fabd0a9e"
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
