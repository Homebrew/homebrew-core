class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v3.2.0.tar.gz"
  sha256 "c93ea23f578c2b2e7e1298d625a3b66e870c58222743657484a84415f54fcd64"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "231e0f5897fef4b23ec503f695038621bea3e677d9442b52ef7187115588538e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66d8fc29334238150e37aed962ff752b633a83dabba30ce2f42c9bd8f58d38c8"
    sha256 cellar: :any_skip_relocation, monterey:       "9c249746ec5c9ca880da944a8fc4859efbc9541dc32522e42a03511e1aeb3159"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5160391e2d94fe12618b6ec9c7e7b0c3e4081e81a3cb982bfe07ea60abeea8b"
    sha256 cellar: :any_skip_relocation, catalina:       "38a57e1b3340a57e6632b6c66f85c7c4dea41e38c3f7b3719d238fa90391e545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4092d8e9ec258c17a40a6467895a6bdf783def3d16ab05206926068aa100ae61"
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
