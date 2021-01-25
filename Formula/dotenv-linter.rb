class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v3.0.0.tar.gz"
  sha256 "a858a4ff6121ec9d9a8889b8bb8d3fd88497c8142c5c5d087a6f169bfd19d73f"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "851044d08dcdaa0d16d0fd1cc0743b7539ef464b7c708137a065f78e9b6d5727" => :big_sur
    sha256 "394d505159a7fa57862d7231e2aad10ce33836f54dbfbc2010c1d57d5172eb27" => :arm64_big_sur
    sha256 "7e21af0a9acb92e757a0d0b1b086548c91ea8ef10cce7487797f9bc2c66825ba" => :catalina
    sha256 "d9cd2cfa877f183617e0154482350605934e6a4fbbddff0c002299fbb079d87b" => :mojave
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
    assert_match /\.env:2\s+DuplicatedKey/, output
    assert_match /\.env:3\s+UnorderedKey/, output
    assert_match /\.env.test:1\s+LeadingCharacter/, output
  end
end
