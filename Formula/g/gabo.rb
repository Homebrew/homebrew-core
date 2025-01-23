class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4d125639d20b5268aab3af96fe65cdbeb4b26030d1590105f757e02d874869a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f55431c042ddb4204746d8b42fbf6c3f2b3cf4e8370f95ad5a36a205e57cbbd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f55431c042ddb4204746d8b42fbf6c3f2b3cf4e8370f95ad5a36a205e57cbbd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f55431c042ddb4204746d8b42fbf6c3f2b3cf4e8370f95ad5a36a205e57cbbd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b95d6c2a8e2326651e71168129b741d95d3842291e4d02233ef9d68ebc1e73f6"
    sha256 cellar: :any_skip_relocation, ventura:       "b95d6c2a8e2326651e71168129b741d95d3842291e4d02233ef9d68ebc1e73f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc811507c1f8b75f900f67e06c4577ba69ddd776b2a15f79c26965baabada5b"
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
    assert_predicate gabo_test/".github/workflows/lint-yaml.yaml", :exist?
  end
end
