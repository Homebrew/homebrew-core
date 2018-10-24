class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/2.2.0.tar.gz"
  sha256 "0751e599188143e01b0f670d09a777998290f680cacaab22abc07a34e9e987d5"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d23b28bbf40354adf65cc45ff43ace00835010d170dccf63ddf5efac1b389a1" => :mojave
    sha256 "449ab8eca7847b30c96abcae0f9f857cd4d2fdb8590bb7150840cef6e8dd4832" => :high_sierra
    sha256 "449ab8eca7847b30c96abcae0f9f857cd4d2fdb8590bb7150840cef6e8dd4832" => :sierra
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
