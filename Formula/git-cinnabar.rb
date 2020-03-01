class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.4.tar.gz"
  sha256 "11980dc0d4d7a291930e4c7f7f4a3f2086fac0f0c9d7cd1dee0292cb0e245010"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "14d1692f6e1ad6300606bb326dd51de8e0ecfc2f1e717c9a284bf3f340135ca0" => :catalina
    sha256 "49ad5487c52527003f21530fc3b90798f0e98c9e06349dd4b54ed1da1cd01e90" => :mojave
    sha256 "ff5dfe2f7f2dbd0af4ba0224c926a74790f1389ccb0a0192537240c6982120a5" => :high_sierra
  end

  depends_on "mercurial"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
