class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "97fc319a570b9ad3d20f644a14a481a69cf639d6429ca59849b650c489fb1724"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "830195b0e2a5fbd680ce06c51f3977e28cb2e55156b23bc35becaf29495ac06a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "830195b0e2a5fbd680ce06c51f3977e28cb2e55156b23bc35becaf29495ac06a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "830195b0e2a5fbd680ce06c51f3977e28cb2e55156b23bc35becaf29495ac06a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e9d1a989ee8166042b03b1e3b9d9d0cdbe42cf680ffb3a56dbef3d7e6cea5474"
    sha256 cellar: :any,                 x86_64_linux:      "fb29cac395f165b856e2f5bbc3a7e50e6fac40aa2c0a62eb5654d51a8d5db4c1"
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
