class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/2.2.0.tar.gz"
  sha256 "0751e599188143e01b0f670d09a777998290f680cacaab22abc07a34e9e987d5"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31dd987e8a3e49e804fde9d67a48cbeec54cfbcbc8e7ee6ce5fc8c344519eb28" => :mojave
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
