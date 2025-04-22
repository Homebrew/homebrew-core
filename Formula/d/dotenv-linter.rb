class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "ffcd2f0d5bb40a19ea747ad7786fea796a7454f51e6da8f37fec572da8ae3c5f"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e74128c4d30c2a6528fc6a02f79e6e33ccd6a742110726025f02b71ea19e46df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "981a11e38772c78552307b2c72983ca365ca9f40778a7cfce3f313d202d9ccf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "061184afd4a55c9b9a1095ab0adc9306fea34473b79908e31d63b3322952b4fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2758e27ba06e8c9593de63f69e0de848137ce7d0f176a6ddc61e5cd3584d5aff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce2bfeff94f6b0d50d14e690054038172d7ad26800f4eb9031f88eb9b390c9e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdbc5c9441782795e7e1ec27befc257875e880b48111dc111d545933084b18c1"
    sha256 cellar: :any_skip_relocation, ventura:        "a5ee9c2f5b214a98f6f132647cca658fbfe71e6fac928323cbc75da3d28d92ce"
    sha256 cellar: :any_skip_relocation, monterey:       "5d16c28fec308fcc777002e6a6c58ae798ac141898c3b8c68242dbab9b9160b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a575348fa033223614c4dac49591ad81129238c3d8675d3e7a26fed6989e446e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c1d24d5ee409f3bdca9f8b112f29be3bd7c6212ffbac08f516b5c2f0d2ec5461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "374ba41dd72196bdcdf510f52e42a74d0ee35eb96c4ba47bbb88cad7e298d023"
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
    output = shell_output(bin/"dotenv-linter", 1)
    assert_match(/\.env:2\s+DuplicatedKey/, output)
    assert_match(/\.env:3\s+UnorderedKey/, output)
    assert_match(/\.env.test:1\s+LeadingCharacter/, output)
  end
end
