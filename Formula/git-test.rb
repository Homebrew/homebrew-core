class GitTest < Formula
  desc "Run tests on each distinct tree in a revision list"
  homepage "https://github.com/spotify/git-test"
  url "https://github.com/spotify/git-test/archive/v1.0.2.tar.gz"
  sha256 "d07ead646d12218b857fe756cc04e15a9bd200726ff5d3692ef17b80cdc6ccc6"

  bottle :unneeded

  # Fixes two tests in the test.sh in the test block
  # Reported 17 Jul 2016: https://github.com/spotify/git-test/issues/10
  patch do
    url "https://github.com/spotify/git-test/pull/11.patch"
    sha256 "b69e23e66b61d9333876fdb6756949d19b24ac03ed5052a576b84b74a88616b6"
  end

  def install
    pkgshare.install "test.sh"
    bin.install "git-test"
    man1.install "git-test.1"
  end

  test do
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
