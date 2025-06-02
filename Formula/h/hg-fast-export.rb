class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/refs/tags/v250330.tar.gz"
  sha256 "1c4785f1e9e63e0ada87e0be5a7236d6889eea98975800671e3c3805b54bf801"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1030f2a360f970ad4d58c661adb4793be8e4abcf4f602e0d0e217a601542e0b"
  end

  depends_on "mercurial"
  depends_on "python@3.13"

  def install
    # The Python executable is tested from PATH
    # Prepend ours Python to the executable candidate list (python2 python python3)
    # See https://github.com/Homebrew/homebrew-core/pull/90709#issuecomment-988548657
    %w[hg-fast-export.sh hg-reset.sh].each do |f|
      inreplace f, "for python_cmd in ",
                   "for python_cmd in '#{which("python3.13")}' "
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
      system bin/"hg-fast-export.sh", "-r", "#{testpath}/hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_path_exists testpath/"git-repo/test.txt"
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
