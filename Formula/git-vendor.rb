class GitVendor < Formula
  desc "Command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.2.1.tar.gz"
  sha256 "7e2fb2f0299b8af152b5c9fd16133d50263a52dc8ecdc7a06111f7c0c5afc184"
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
