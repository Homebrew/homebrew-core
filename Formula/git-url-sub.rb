class GitUrlSub < Formula
  desc "Recursively substitute remote URLs for multiple repos"
  homepage "https://gosuri.github.io/git-url-sub"
  url "https://github.com/gosuri/git-url-sub/archive/1.0.1.tar.gz"
  sha256 "6c943b55087e786e680d360cb9e085d8f1d7b9233c88e8f2e6a36f8e598a00a9"

  head "https://github.com/gosuri/git-url-sub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fcf47332e070caed126fef2be0a1108a23e18a9d1ba80b6059b45a417af1b31" => :sierra
    sha256 "cf954ff293abbcaf8816c8142b5762ebe7601107f76530f6bab0edea71e2d609" => :el_capitan
    sha256 "2edfbc5f15001b1c4c08b26251a845533473a79bc2f387d3fd1d74751080cd1b" => :yosemite
    sha256 "ce9c28238d1904b9d2c97da10fd7a6be0b1ceafde423311078dfac0bbe8a82dc" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "foo"
    system "#{bin}/git-url-sub", "-c", "foo", "bar"
    assert_match(/origin\s+bar \(fetch\)/, shell_output("git remote -v"))
  end
end
