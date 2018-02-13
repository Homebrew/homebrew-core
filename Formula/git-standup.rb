class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/2.1.9.tar.gz"
  sha256 "6f6ff39e7d1cbf51783bc42fbc61ad38f84efdd441c183cef0d75187c1ea7087"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0eb22ac35b48f9696da523eb85270a5a0e6652d35c921a5c80b195d3e1f39c2" => :high_sierra
    sha256 "a0eb22ac35b48f9696da523eb85270a5a0e6652d35c921a5c80b195d3e1f39c2" => :sierra
    sha256 "a0eb22ac35b48f9696da523eb85270a5a0e6652d35c921a5c80b195d3e1f39c2" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "#{testpath}/test"
    system "git", "commit", "--message", "test"
    system "git", "standup"
  end
end
