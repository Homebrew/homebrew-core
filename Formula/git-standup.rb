class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/2.3.2.tar.gz"
  sha256 "48d5aaa3c585037c950fa99dd5be8a7e9af959aacacde9fe94143e4e0bfcd6ba"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "204ee383d2909e26a711b6652c281d55c6bfa453e25ad429a761c8437e2e03c0" => :catalina
    sha256 "110abc4176efa17c98a31c8f9d3efff8f2bdb68096fe3214bd10ae5b153f61d2" => :mojave
    sha256 "7e1457e523902625e5bdf66248f2eaa058ee927fd5673c42773a58f18fb9badd" => :high_sierra
    sha256 "7e1457e523902625e5bdf66248f2eaa058ee927fd5673c42773a58f18fb9badd" => :sierra
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
