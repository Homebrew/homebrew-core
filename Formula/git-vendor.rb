class GitVendor < Formula
  desc "Command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.2.2.tar.gz"
  sha256 "f7b3b73ab2246a7572d55eec4e634467bd1ae9414aae8f11a1d4e59e587326ca"
  license "MIT"
  head "https://github.com/brettlangdon/git-vendor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ad163b4e752517720cf3ed6c8de5c67c1fa88764ebfeb793d81bf22d29b3cc1"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "author@example.com"
    system "git", "config", "user.name", "Au Thor"
    system "git", "add", "."
    system "git", "commit", "-m", "Initial commit"
    system "git", "vendor", "add", "git-vendor", "https://github.com/brettlangdon/git-vendor", "v1.1.0"
    assert_match "git-vendor@v1.1.0", shell_output("git vendor list")
  end
end
