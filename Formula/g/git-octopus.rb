class GitOctopus < Formula
  desc "Continuous merge workflow"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/refs/tags/v1.4.tar.gz"
  sha256 "e2800eea829c6fc74da0d3f3fcb3f7d328d1ac8fbb7b2eca8c651c0c903a50c3"
  license "LGPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "85596e8a14e47ed9ca1982b4ae0fb3c3afd7bc991722d8e19045a406055d13e0"
  end

  deprecate! date: "2025-12-14", because: :repo_archived

  def install
    system "make", "build"
    bin.install "bin/git-octopus", "bin/git-conflict", "bin/git-apply-conflict-resolution"
    man1.install "doc/git-octopus.1", "doc/git-conflict.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "."
    system "git", "commit", "--message", "brewing"

    assert_empty shell_output("#{bin}/git-octopus 2>&1").strip
  end
end
