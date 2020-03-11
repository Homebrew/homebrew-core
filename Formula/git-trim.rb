class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.2.4.tar.gz"
  sha256 "7c3c386cdca7eeec8a8a3d959e80ec088be9db5300d9db21d639878b725cf64f"

  bottle do
    cellar :any
    sha256 "3b432c06e89d248aba054cefe6b6472fa524642bed36c95d5a2c4c3c048ddd2b" => :catalina
    sha256 "6410b2132e6be08bcfcbd12d9f4baf918ebd51bfd1d7c7acc18836522df15eaf" => :mojave
    sha256 "3ca739e92e5eee4b1420b16d4d4f6d034a1181357f7105c4997bc2a16b552fd9" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "docs/git-trim.md.1" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
