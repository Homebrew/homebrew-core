class DotenvLinter < Formula
  desc "Lightning-fast linter for .env files written in Rust"
  homepage "https://dotenv-linter.github.io"
  url "https://github.com/dotenv-linter/dotenv-linter/archive/v3.2.0.tar.gz"
  sha256 "c93ea23f578c2b2e7e1298d625a3b66e870c58222743657484a84415f54fcd64"
  license "MIT"
  head "https://github.com/dotenv-linter/dotenv-linter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c5d2c86aeb6cd06703803fdecbaed47dad1742e0465cb59449663becdd900cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b70c99caadc973689053dbe2036fbc249806f47a472634a5c95365361062a53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6320dbfc3c337c732b8307709d80a3378c63aa6300475b82dc818adfbd2bb746"
    sha256 cellar: :any_skip_relocation, ventura:        "c5775d58fca6491d12d0174c437c2d6a1789f4dfb521198692e266481d96dcc1"
    sha256 cellar: :any_skip_relocation, monterey:       "5fb258b2a1ec2a0362a96c4737494780d76385b8e8795c36875aa507238be054"
    sha256 cellar: :any_skip_relocation, big_sur:        "b218930db55ecf7a3c3a84d9027adb77b7acc009eb6d59700b2dab46464ee38d"
    sha256 cellar: :any_skip_relocation, catalina:       "b8c7248ad397808dff0ed62cd3bf997db6c355571e9bbb3fd3895b711ac97823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e20bddf0db0de8f8d62bcfd14cc8fd2a123fbec9f71cd526c6d0939ee552ac"
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
