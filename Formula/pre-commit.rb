class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.1.0.tar.gz"
  sha256 "105a9a941c48e0f90ef4f429e8dbabe2411e1eb74fbda44ff5ed3f31d637a69d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e5fc2c55552d5cb59b18b7a4a866e3244b0ba9259e0c6c93c5a8577755bc732" => :sierra
    sha256 "dbe4a121bb4266e0f5b6ef4fcac5887fded32f9e665a3d9bf516bf6ddfaf06a8" => :el_capitan
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pre-commit"
    venv.pip_install_and_link buildpath
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<-EOF.undent
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
      EOF
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
