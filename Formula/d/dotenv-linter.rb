class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "c10f63e84a877b630986a59680df20ee3f49ae3f89daa8d7e65f427d31b13a32"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23826a36202a165deaa312c7b0029d0c02eef0d21b49c56d20f2deb23cf38de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18328c0319bad89891c989253a6ee818fe235f9d439bea847a52b936f50521a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9001d81807e8c5e9f7f0284a7ff516d3d72f6f182adf4a5c7a8b82e6f35d89f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f47ec451241a91ccdccb741cd61576f403962637841fcd8b49b8f292ce9e301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a630789bddee63f8c975359e0b77394b6cca50e95abc9ccc3d4988984bdf9030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0da61986447dbdadec3a8634cf19d5eb12d1ce4bb1c61acf53f67c0187b126"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "dotenv-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotenv-linter --version")

    (testpath/".env").write <<~EOS
      FOO=bar
      FOO=bar
      BAR=foo
    EOS

    (testpath/".env.test").write <<~EOS
      1FOO=bar
      _FOO=bar
    EOS

    output = shell_output("#{bin}/dotenv-linter check .env .env.test", 1)
    assert_match(/\.env:2\s+DuplicatedKey/, output)
    assert_match(/\.env:3\s+UnorderedKey/, output)
    assert_match(/\.env.test:1\s+LeadingCharacter/, output)
  end
end
