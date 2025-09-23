class GitTest < Formula
  desc "Run tests on each distinct tree in a revision list"
  homepage "https://github.com/spotify/git-test"
  url "https://github.com/spotify/git-test/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "7c2331c8dc3c815e440ffa1a4dc7a9ff8a28a0a8cbfd195282f53c3e4cb2ee00"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "175c118c1dc9752f40074b529c3d184a8949b222f03c9db5e75a520b76e8842e"
  end

  deprecate! date: "2024-03-04", because: :repo_archived
  disable! date: "2025-03-04", because: :repo_archived

  def install
    bin.install "git-test"
    man1.install "git-test.1"
    pkgshare.install "test.sh"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["GIT_CONFIG_NOSYSTEM"] = "1"
    system "git", "init"
    ln_s bin/"git-test", testpath
    cp pkgshare/"test.sh", testpath
    chmod 0755, "test.sh"
    system "git", "add", "test.sh"
    system "git", "commit", "-m", "initial commit"
    ENV["TERM"] = "xterm"
    system bin/"git-test", "-v", "HEAD", "--verify='./test.sh'"
  end
end
