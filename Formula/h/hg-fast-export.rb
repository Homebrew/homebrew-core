class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/frej/fast-export.git", branch: "master"

  stable do
    url "https://github.com/frej/fast-export/archive/refs/tags/v250330.tar.gz"
    sha256 "1c4785f1e9e63e0ada87e0be5a7236d6889eea98975800671e3c3805b54bf801"

    # Backport fix for mercurial 7.2
    patch do
      url "https://github.com/frej/fast-export/commit/76db75d9631fc90a25f58afa39b72822e792e724.patch?full_index=1"
      sha256 "68c61af1c95ce55e9f41c18cbf6f7858139d6153654d343a639b30712350540b"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "608ef4e7b632bb7795fe1162ad7c351c7c50f25ddd684075f3d353cbda11a0e6"
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
      system bin/"hg-fast-export.sh", "-r", testpath/"hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_path_exists testpath/"git-repo/test.txt"
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
