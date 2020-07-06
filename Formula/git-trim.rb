class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.3.2.tar.gz"
  sha256 "08c65f0e821b12f5e512034df22723be9289e42102d478dae759f57905554f25"
  license "MIT"

  bottle do
    cellar :any
    sha256 "291284c8fc2191487bcc55ea41a0de621e705b3ae141f91226cb843b5be408af" => :catalina
    sha256 "a41fdd1acd98185e906be41cb1ca658e50e32fc3461a9d5ef5d10a1aed9c7e11" => :mojave
    sha256 "e0c2c87d6d4aad24751f3dded41c6e8f68300eaef2a9721eea92508bb9ccc32c" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
