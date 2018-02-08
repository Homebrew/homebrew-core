class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/2.1.9.tar.gz"
  sha256 "6f6ff39e7d1cbf51783bc42fbc61ad38f84efdd441c183cef0d75187c1ea7087"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51a88b45f96516d5950e1abc797504198817b7c12c7e3a50fc1f454b1d831630" => :high_sierra
    sha256 "15ba95a266e75f91c131ac4ba97c8c1f2b8eee5f84e6bf3f8ae4b6c31d4e0046" => :sierra
    sha256 "8da88a1d4e590d8e2ec6bef3f34c2f88817c89b1473cde291b8ee6c79be6cdef" => :el_capitan
    sha256 "ab3b98ecf47de06d1d5093257bf63675495a5f57d2e94e1ae53757b933736c02" => :yosemite
    sha256 "641e5f5e5dbd1761c88603a5c93d40c2b6b4c93d32ffdd1619acf6db8b14f464" => :mavericks
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
