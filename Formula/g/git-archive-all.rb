class GitArchiveAll < Formula
  include Language::Python::Shebang

  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.23.1.tar.gz"
  sha256 "0c440d15be18e336672549231510fa3c66d0cb95069a5e4800fdd876ab6814df"
  license "MIT"
  head "https://github.com/Kentzo/git-archive-all.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a84fa8b0fb597ad1dde397739735c66689df8cb193d0200c1da06acb097c80e9"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "git_archive_all.py"

    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end
