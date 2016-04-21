class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/1.0.1.tar.gz"
  sha256 "0c43e7414b308bc29ef6f04e84b02aaf3e0ac4837522d34f84359a54c0a4d54b"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle :unneeded

  def install
    bin.install "git-standup"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "#{testpath}/test"
    system "git", "commit", "--message", "test"
    system "git", "standup", "HEAD"
  end
end
