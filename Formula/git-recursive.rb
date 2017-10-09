class GitRecursive < Formula
  desc "Execute git operations in multiple repositories"
  homepage "https://github.com/aelesbao/git-recursive"
  url "https://github.com/aelesbao/git-recursive/archive/0.1.2.tar.gz"
  sha256 "ca18bb20393805a7f67e988e43d02fb4caf2e9119910d2abba0ce46a33fa6d78"

  head "https://github.com/aelesbao/git-recursive.git", :branch => "master"

  bottle :unneeded

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"git-recursive", "add", "test", testpath
    assert_match(/^test.+#{testpath}/, shell_output("#{bin}/git-recursive list"))
    system bin/"git-recursive", "rm", "test"
  end
end
