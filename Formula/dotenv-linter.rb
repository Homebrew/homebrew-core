class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v2.2.1.tar.gz"
  sha256 "0ccf8f221a84c935bb885b863ba54283cc26a9724aae6a15766a387ccc4d3f4d"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    checks = shell_output("#{bin}/dotenv-linter --show-checks").split("\n")
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
    assert_match /\.env:2\s+DuplicatedKey/, output
    assert_match /\.env:3\s+UnorderedKey/, output
    assert_match /\.env.test:1\s+LeadingCharacter/, output
  end
end
