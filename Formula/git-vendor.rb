class GitVendor < Formula
  desc "Command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.2.1.tar.gz"
  sha256 "7e2fb2f0299b8af152b5c9fd16133d50263a52dc8ecdc7a06111f7c0c5afc184"
  license "MIT"
  head "https://github.com/brettlangdon/git-vendor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a32c52d725602c25e460a58d24f99029753aab5a215530bc0717968841bf8f3"
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
