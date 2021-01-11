class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v3.0.0.tar.gz"
  sha256 "a858a4ff6121ec9d9a8889b8bb8d3fd88497c8142c5c5d087a6f169bfd19d73f"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ced7a6252dfccabeef5bebe57d826ff2d47ad169fe675769194ff8a670a74261" => :big_sur
    sha256 "ea3cd8fbb12d6c5aaa962d20a07f6a3aabb418cf6142a9fff057fecbf63c02cd" => :catalina
    sha256 "6dc5965ef3f36811e133c28636dec3b06eed99782fbfc980e83d775722a979e0" => :mojave
    sha256 "8bdecac347a74490c4972a31a4c713cfb438e5531b5dc626fea42d495ad932c3" => :high_sierra
  end

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
