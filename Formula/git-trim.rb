class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.2.4.tar.gz"
  sha256 "7c3c386cdca7eeec8a8a3d959e80ec088be9db5300d9db21d639878b725cf64f"

  bottle do
    cellar :any
    sha256 "43c93225e3bced1921b69adf6d503bed99909c57945859a69a63b86c7d5b8c1f" => :catalina
    sha256 "d0a4dd74552c09184e17bad80436c180697415482fc8487d6cf3cf6c0ac4101a" => :mojave
    sha256 "78d5690223b4a6124946b5e51aab51190f854a8033d488942484fc38aeb2be82" => :high_sierra
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
