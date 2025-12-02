class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/refs/tags/v250330.tar.gz"
  sha256 "1c4785f1e9e63e0ada87e0be5a7236d6889eea98975800671e3c3805b54bf801"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/frej/fast-export.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5bb15dd75663590054cdcdd88d472155e5cea8f520ddd1ecd234b957bb733d5"
  end

  depends_on "mercurial"
  depends_on "python@3.14"

  def install
    python3 = which("python3.14")
    libexec.install "plugins", "pluginloader"
    bin.install buildpath.glob("hg*.{sh,py}")

    rewrite_shebang detected_python_shebang, *bin.children
    bin.env_script_all_files libexec/"bin", PYTHON: python3, PYTHONPATH: libexec
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
