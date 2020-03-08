class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v2.1.1.tar.gz"
  sha256 "0b80e45b4e001f45bade0f1cc2d891eb810de154f1eb703a1f77ac060a9a07ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "24692c6d05f9e60b6ffb29ea6f110de52ecf6929bd8b3569e72c10d121059093" => :catalina
    sha256 "fcba832e25006b372b25d92fecafbfbce3fe415d9aa80973c98c3b1645cf23bb" => :mojave
    sha256 "239b6b495d41b65e5746d3fce4a4866c5c24d04ff67ddd15d9c2bf7a1a0a5828" => :high_sierra
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
