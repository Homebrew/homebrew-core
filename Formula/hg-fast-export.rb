class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v221024.tar.gz"
  sha256 "0dfecc3a2fd0833434d7ef57eb34c16432a8b2930df22a56ccf1a2bbb4626ba7"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e34f2ca7004b96237a3ccb2c6f611e5a5062c843dc632da74c5b8ac0aa3852df"
  end

  depends_on "mercurial"
  depends_on "python@3.11"

  def install
    # The Python executable is tested from PATH
    # Prepend ours Python to the executable candidate list (python2 python python3)
    # See https://github.com/Homebrew/homebrew-core/pull/90709#issuecomment-988548657
    %w[hg-fast-export.sh hg-reset.sh].each do |f|
      inreplace f, "for python_cmd in ",
                   "for python_cmd in '#{which("python3.11")}' "
    end

    libexec.install Dir["*"]

    %w[hg-fast-export.py hg-fast-export.sh hg-reset.py hg-reset.sh hg2git.py].each do |f|
      rewrite_shebang detected_python_shebang, libexec/f
      bin.install_symlink libexec/f
    end
  end

  test do
    mkdir testpath/"hg-repo" do
      system "hg", "init"
      (testpath/"hg-repo/test.txt").write "Hello"
      system "hg", "add", "test.txt"
      system "hg", "commit", "-u", "test@test", "-m", "test"
    end

    mkdir testpath/"git-repo" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system "hg-fast-export.sh", "-r", "#{testpath}/hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_predicate testpath/"git-repo/test.txt", :exist?
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
