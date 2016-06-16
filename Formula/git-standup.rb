class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/2.1.7.tar.gz"
  sha256 "06df54dd7fb04182afa1485bf3dabdf7d5fef039d297f684a6ca4b1b86025c11"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee1dcd5c5f5ad8a35848b7543245eac363cb54c689fedbb18b9084f76c97d0ab" => :el_capitan
    sha256 "7aa37c62927c3aa039b7f9588d7fa67bc6f9c1ada424f78c2a2e802eae1e11c5" => :yosemite
    sha256 "cf032c7c41a91355bde6be7c902445885ba6dcc4b6c90356b263729be9b1dbaa" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "#{testpath}/test"
    system "git", "commit", "--message", "test"
    system "git", "standup"
  end
end
