class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v210917.tar.gz"
  sha256 "168f51301f01b4a2572bb00dd9474ee9a50b85f24aa5ed5a7b8abb12896d951a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6532a51ead9d46a0ae6f957ae12f62467d265a741b2cf4be23b0808ed2be1fe"
  end

  depends_on "mercurial"
  depends_on "python@3.9"

  def install
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
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system "hg-fast-export.sh", "-r", "#{testpath}/hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_predicate testpath/"git-repo/test.txt", :exist?
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
