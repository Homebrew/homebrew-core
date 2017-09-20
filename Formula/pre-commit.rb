class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.1.2.tar.gz"
  sha256 "53dcde73b89380151f4a86577acea2b03fc81335d1f6034beea3a80feec649d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0dc2f37f3d969c171d64da46ceb30eb8868c215e2a74e780037c19592336dee" => :sierra
    sha256 "fce58b216c9329a96323c98567414cbffe4f3118e4e4a15a2614eb7c2192a9b1" => :el_capitan
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
