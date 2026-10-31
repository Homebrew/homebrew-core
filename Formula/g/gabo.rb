class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "90fc9f21a9d2193e4a20c9c867dd508af41483e65cc3a1bbca3a81c8b4ead076"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "767490ddd73c994beb6aae99344e8b2c72a279c855e45ed03e1e4b47e7d6ff09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "767490ddd73c994beb6aae99344e8b2c72a279c855e45ed03e1e4b47e7d6ff09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "767490ddd73c994beb6aae99344e8b2c72a279c855e45ed03e1e4b47e7d6ff09"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b3c866b1673dacbfad001c07dcf0170461a5c0c7d5e99269815f091ad827296"
    sha256 cellar: :any,                 x86_64_linux:      "b4f716f51f5175c13e800300b160a285076ac834cb3f73091a27fab1d0ece791"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src/gabo"
  end

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args, "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end
