class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "674029ba6af49294147d7f5b3757d4e3eb0c5e0e23e44883410f7b233d678679"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ffc847086a9eafb6049a38a4512f498983962fde7dafb53c61a482df019aaf8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffc847086a9eafb6049a38a4512f498983962fde7dafb53c61a482df019aaf8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ffc847086a9eafb6049a38a4512f498983962fde7dafb53c61a482df019aaf8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ffc847086a9eafb6049a38a4512f498983962fde7dafb53c61a482df019aaf8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0fe0c3f9f56a2a5954828fef647c6b567ffa6e61ee5bb9018024a8081f90914"
    sha256 cellar: :any,                 x86_64_linux:      "87cb31835e7b2846dd84ce8b2f36006817d5dceb10d0f88b494b643d23958270"
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
