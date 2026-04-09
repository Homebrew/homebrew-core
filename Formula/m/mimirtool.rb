class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.0.5",
        revision: "7f53a94e516d5a7b55966ebdfb369c8b8fb1718b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "428bdde9be8864e29b6654481e87ee698eb2ee4b202f187cb57d9a3ef541a2d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035530cdde31e0acc58e8b55ecb761529a413f8a61803839a764028eda164684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7bfd29198f3b7ed496d34258e81965f4b603363c8213f0fe5773413b9884ac0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4cb2a048b3a406287442001d779cdc666e31691bfb9da24d5e6ae491ec8555f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "500c910433e82a3476cce1874e6f2f68a770c05e79722a2a8363df2059f89368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c7be42543db0b201324e901e410b15132369fa807708d1ef340472ddc0453a"
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
