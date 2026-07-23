class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "d53be453b5897025dc1c2ceac0adbb58e4082772c9a3f0cd7fc7f6c038ec5add"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a18f143f6c814e94c351519720e2a61c5ed57a39f9fad2e65053e4c09345c1c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a18f143f6c814e94c351519720e2a61c5ed57a39f9fad2e65053e4c09345c1c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a18f143f6c814e94c351519720e2a61c5ed57a39f9fad2e65053e4c09345c1c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd5ecbde67b69e3e21d7f0da43eb3154fe34eb746dcd135edc6f4af51c8e7db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d01e017f5929d9b6ff8ba9ddee02c24064a711d5206374eaf3b17384b610352f"
    sha256 cellar: :any,                 x86_64_linux:  "539f7487cfe8efd92e6569cdf4b01ec3e21bf8bd8d816bd921f8f1ce0e32f327"
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
