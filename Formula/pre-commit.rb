class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v2.3.0.tar.gz"
  sha256 "cbe534c57d0e0e17b0a739d71bb0d33a3bc295e65d6d125860bcfc7053abd645"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a7f0335e863020359410ccffc9c4272751b041b99017c3b870ee24c57b05fae" => :catalina
    sha256 "7c00f08c4571d9b956f192b974c5a64ce458636a80c6723b0f6af354c6db9f8c" => :mojave
    sha256 "ed68993f6703cccc5766c87a346a40131f429a55a4f1587c3acee1c7a6c07ab1" => :high_sierra
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
