class HgFastExport < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/refs/tags/v250330.tar.gz"
  sha256 "1c4785f1e9e63e0ada87e0be5a7236d6889eea98975800671e3c3805b54bf801"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/frej/fast-export.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26cbfd49c68c6f13eadcd0d6365eaa554aae4ea236b78780a87664f6795be7e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e452579006d0079f87d4d472b2932ce585a2730058996782cf0b6054cd8e422e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aa8a9b701199c436905cfa33617ac33bf918e08fbc6c820defdded2dd83c9e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "22d6c095c84ff4fdee418459f3aa0e9ceeef33de364dda42d24bd90232a7cf65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03cc5550a9adbe61efadcf56051885cc423d933ecf75bf43d74914090d9d4c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7799b942685a7fa60d59a8e9b77c2d8865a681c55ddcefa2d5b23c05fbb2360"
  end

  depends_on "mercurial" => :test
  depends_on "python@3.14"

  # TODO: Switch back to formula after https://github.com/frej/fast-export/issues/348
  resource "mercurial" do
    url "https://www.mercurial-scm.org/release/mercurial-7.1.2.tar.gz"
    sha256 "ce27b9a4767cf2ea496b51468bae512fa6a6eaf0891e49f8961dc694b4dc81ca"
  end

  def install
    python3 = which("python3.14")
    libexec.install "plugins", "pluginloader"
    bin.install buildpath.glob("hg*.{sh,py}")

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("mercurial")
    venv_python = venv.root/"bin/python"

    rewrite_shebang python_shebang_rewrite_info(venv_python), *bin.children
    bin.env_script_all_files libexec/"bin", PYTHON: venv_python, PYTHONPATH: libexec
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
      system bin/"hg-fast-export.sh", "-r", testpath/"hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_path_exists testpath/"git-repo/test.txt"
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
