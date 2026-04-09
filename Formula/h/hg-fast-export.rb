class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/refs/tags/v260405.tar.gz"
  sha256 "23af10aed62096a25f54012e37a16f5137d221f7e862dd559eba1ecf56ff1dbe"
  license "GPL-2.0-or-later"
  head "https://github.com/frej/fast-export.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d63cc3af8e41294758be1e5b4b50e4a4fa117f7d9ce782afb62ad2629db42cdc"
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
