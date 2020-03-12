class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v2.2.0.tar.gz"
  sha256 "53a5d39e8b2063a004ecdabd4b459ae826cfe47eca449720e4fdde06a7d43cc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "19edc7767d3773b8d163e9425c1743929fcd13e8225189b269a8233a1f91388c" => :catalina
    sha256 "71ae720d396e735387c22ff024d224cedb708ef7198cb248c7d065942c03cff2" => :mojave
    sha256 "06e8911ccc3018eca8b39e624c380313ead9d28fbb79f5d7364a7260a3cb27c5" => :high_sierra
  end

  # To avoid breaking existing git hooks when we update Python,
  # we should never depend on a versioned Python formula and
  # always use the "default".
  depends_on "python"

  def install
    # Make sure we are actually using Homebrew's Python
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'#!/usr/bin/env {py}'",
              "'#!#{Formula["python"].opt_bin}/python3'"

    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pre-commit"
    venv.pip_install_and_link buildpath
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<~EOS
        -   repo: https://github.com/pre-commit/pre-commit-hooks
            sha: v0.9.1
            hooks:
            -   id: trailing-whitespace
      EOS
      system bin/"pre-commit", "install"
      (testpath/"f").write "hi\n"
      system "git", "add", "f"

      ENV["GIT_AUTHOR_NAME"] = "test user"
      ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
      ENV["GIT_COMMITTER_NAME"] = "test user"
      ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
      git_exe = which("git")
      ENV["PATH"] = "/usr/bin:/bin"
      system git_exe, "commit", "-m", "test"
    end
  end
end
