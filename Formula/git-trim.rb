class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.3.2.tar.gz"
  sha256 "08c65f0e821b12f5e512034df22723be9289e42102d478dae759f57905554f25"

  bottle do
    cellar :any
    sha256 "299010c734f65b31c9114a5c3f59603910ba9d54a3e754e54549c1d059a3af3c" => :catalina
    sha256 "8c6410e3846f5ae8cc7f45213484611bf6e980f0c18a21e1679be50379029101" => :mojave
    sha256 "a38597f8f12b97c20b080ee67589cdf3c6d1e391d3420cfe8c9af307d326bd5b" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
