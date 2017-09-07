class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.18.3.tar.gz"
  sha256 "ae43eda583fad65a8cc67b793c72f98234bdbb56b1a706349c936fd478af489b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a323b70bdddc1f4b0554f7b3d0aa8dadb764adf5b7b3636c09b0f3ae0d312825" => :sierra
    sha256 "f81512b5e0e784c7909f29b13a681c8f76fc564a7dbca9874badcbd50dbf9e30" => :el_capitan
    sha256 "4d82c1ef709431863108096eec18c83969a1d2a8f20f3677a5438dd0bbea18ff" => :yosemite
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
