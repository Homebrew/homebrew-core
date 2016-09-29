class Git182Requirement < Requirement
  fatal true
  default_formula "git"

  satisfy do
    system "git stripspace --comment-lines </dev/null 2>/dev/null"
  end

  def message
    "Your Git is too old.  Please upgrade to Git 1.8.2 or newer."
  end
end

class GitIntegration < Formula
  desc "Manage git integration branches"
  homepage "https://johnkeeping.github.io/git-integration/"
  url "https://github.com/johnkeeping/git-integration/archive/v0.4.tar.gz"
  sha256 "b0259e90dca29c71f6afec4bfdea41fe9c08825e740ce18409cfdbd34289cc02"
  head "https://github.com/johnkeeping/git-integration.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4679cfcf05245017bf840a67eeecf0fde1b52862d46d00e9f80d267c33aedbe" => :sierra
    sha256 "f91de5bf8a16b8b54db99566b81862c7d1e898dd332fd2d4d4bd457694443d62" => :el_capitan
    sha256 "149a1f6f3cc6a413795893c6d63d48e82264a383aa901bee796c4d6a217b0c9b" => :yosemite
    sha256 "2bae67c0933f3e0e990a12f1f90dd319cd788736a0cb50ad9f57e01195639331" => :mavericks
  end

  depends_on "asciidoc" => [:build, :optional]
  depends_on Git182Requirement

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    (buildpath/"config.mak").write "prefix = #{prefix}"
    system "make", "install"
    if build.with? "asciidoc"
      system "make", "install-doc"
    end
    system "make", "install-completion"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "An initial commit"
    system "git", "checkout", "-b", "branch-a", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-a"
    system "git", "checkout", "-b", "branch-b", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-b"
    system "git", "checkout", "master"
    system "git", "integration", "--create", "integration"
    system "git", "integration", "--add", "branch-a"
    system "git", "integration", "--add", "branch-b"
    system "git", "integration", "--rebuild"
  end
end
