class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v3.3.0.tar.gz"
  sha256 "ffcd2f0d5bb40a19ea747ad7786fea796a7454f51e6da8f37fec572da8ae3c5f"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63cf0b41654d7400a69e02a2e1f62add8cf0dfcbe2d1a25e2488d90edcf0b335"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e254bf85ec318b79a7106efc1e186a99eddc6db73e21c2bc9cc58f703587f137"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "470451a731ba381ad8c220c6380a557b325a112cbd7cc57b25883c951972f6e9"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8d22f0d37d43b69853b34b5e9e8c80d0ed514bac0b336d1239c398ca42e980"
    sha256 cellar: :any_skip_relocation, monterey:       "d3fceb50a7f92ddf61ac56e9daa80ff230a29a9474438e129b807e123ae79aae"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d2656a480a42fa1ada99abc99a101a8744073b839a088891a93e5f75ca000dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31bc47faa9df9655396adbc0c1b137cb8491c1a13b933d0c2ac5edbd339f866f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    checks = shell_output("#{bin}/dotenv-linter list").split("\n")
    assert_includes checks, "DuplicatedKey"
    assert_includes checks, "UnorderedKey"
    assert_includes checks, "LeadingCharacter"

    (testpath/".env").write <<~EOS
      FOO=bar
      FOO=bar
      BAR=foo
    EOS
    (testpath/".env.test").write <<~EOS
      1FOO=bar
      _FOO=bar
    EOS
    output = shell_output("#{bin}/dotenv-linter", 1)
    assert_match(/\.env:2\s+DuplicatedKey/, output)
    assert_match(/\.env:3\s+UnorderedKey/, output)
    assert_match(/\.env.test:1\s+LeadingCharacter/, output)
  end
end
