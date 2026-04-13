class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "40ef49ee16cefd0c0c798fea45359c3d134fbb3efe409741748424a601ce3237"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3659a389fc76d79407a2de7a8dd369127660cb9c2ada08e879773d5ea1762e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3659a389fc76d79407a2de7a8dd369127660cb9c2ada08e879773d5ea1762e1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3659a389fc76d79407a2de7a8dd369127660cb9c2ada08e879773d5ea1762e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "994c91ef72296ef74b4b3fe5f50812496a89af47a349f71ef0fbcdc81e520ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eee6684aee5f9f722a8b334321baa60fe99fcba37bea844be5e6e1c07c87232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180b4ea968743c12bda33337f189b9f0ee00c80b2c003d520fd4b5ff0733eaad"
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
