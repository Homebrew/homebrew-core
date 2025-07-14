class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "65058964f6cde5914a93c1277864f26ec408fc5ac78750241c4da99075f1e220"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c1cdf8a18781bae6be0ec814712a0442a70e3ba76c28b393bcfbc973c8deca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c1cdf8a18781bae6be0ec814712a0442a70e3ba76c28b393bcfbc973c8deca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1c1cdf8a18781bae6be0ec814712a0442a70e3ba76c28b393bcfbc973c8deca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1af0af9db03f9285342bb360ef193a3f381eda17f33fe43993ad1dc91d2d855"
    sha256 cellar: :any_skip_relocation, ventura:       "f1af0af9db03f9285342bb360ef193a3f381eda17f33fe43993ad1dc91d2d855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a8deea09ebaa4f74fb615e8311eb117c88af0b39918e3caeb540934ae9123d"
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
