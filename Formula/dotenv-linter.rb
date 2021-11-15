class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v3.1.1.tar.gz"
  sha256 "662856500db625c34b14f699a5e6f64af7fed0b2e06b6b8fee47103b637f1435"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c04c036c9bcece657db245e527c7fb89d201c7a9dda9033745fa040f2639d56a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcfbdff2f21f9d7fa1b28bf5edb68c695721eec092b4e240ec68d5102c565050"
    sha256 cellar: :any_skip_relocation, monterey:       "8dcff983c616efd4e2b0ec0acfd3228fb989627ea85e2592c58df7352ed92ce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b6fd178bf335818ffc7e35a7f333bb47bb451829c24671e70f4140e37e0e080"
    sha256 cellar: :any_skip_relocation, catalina:       "2f6ccdd1a2c589bbea2deefdbf5f017a9c0380cc1ee4e6e16f45b0160fe1faa6"
    sha256 cellar: :any_skip_relocation, mojave:         "ca344c71611590a50f18c25c7dc4a1dc945d018e9de8fb77fb4b67db516761f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b46bf6ca08601e0af98d5cd1fecb715d1789c1df8e2c358255a2fd93eda0d6"
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
