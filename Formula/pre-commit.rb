class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.3.0.tar.gz"
  sha256 "e4ba7733693c678b17465d5717b26031c5d0a08689ecfbc75887049e99f097de"

  bottle do
    cellar :any_skip_relocation
    sha256 "d61422715bd65fe95310f1d6447ac88ae3a3c1ec9f9b9fd9f2d68a9e7bf1a038" => :high_sierra
    sha256 "87e880095a6b7ba8ae05394c1f97add7fa6265613c60634c41965237ddfaf310" => :sierra
    sha256 "17698be7a121949a0f3dfee96f5df9df22b609e6747971e5cb2d246487407536" => :el_capitan
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
      (testpath/".pre-commit-config.yaml").write <<~EOF
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
