class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v3.1.0.tar.gz"
  sha256 "1b41740a061dc02ba11680d6fe28c6a961a16f8177d06042db68c0249f731070"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "184f8f44c290ad4ad9e151fb2f147348711bfc02d007124070c143a3bdd46bd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "5155e044174d3ee0ec043c1543156906a6b2ba9bc24a8d3ba4e6ba24677ec90a"
    sha256 cellar: :any_skip_relocation, catalina:      "9def48cd0fa0f35d763898d62889faeb1371d8589623c6c607aaa7815a36b2e7"
    sha256 cellar: :any_skip_relocation, mojave:        "d23716aa6cba002d9629ca02547d05f964754b7ac575dd00e2d83ee6df1b4e8a"
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
