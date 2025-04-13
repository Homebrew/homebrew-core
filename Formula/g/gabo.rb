class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e9f35080fc54490c5bba5eea27f6b336d3741c29ad039f270a1511d07d3e2cda"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45cd2db844081e8bca9262d1858ab1e0f96f7efa9c8f21eb4c0ee38c9a06c03f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45cd2db844081e8bca9262d1858ab1e0f96f7efa9c8f21eb4c0ee38c9a06c03f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45cd2db844081e8bca9262d1858ab1e0f96f7efa9c8f21eb4c0ee38c9a06c03f"
    sha256 cellar: :any_skip_relocation, sonoma:        "711ab98807f579d7f5901d3bc3ee4aeb816c6328f8a2e2136c612547004202de"
    sha256 cellar: :any_skip_relocation, ventura:       "711ab98807f579d7f5901d3bc3ee4aeb816c6328f8a2e2136c612547004202de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37593db2caea79cf6ea7e44f701aa67b13910cd96566bb43bb922e6438155712"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
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
