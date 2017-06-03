class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.14.1.tar.gz"
  sha256 "04d21c88cece376a30ca12f99413032775d83875e7caf4e5a9b57a4008dade21"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9197eb93a71b743347b687889511f184ee5e5ede8af895512a36db077e8b12e" => :sierra
    sha256 "9f05f42053079cfc4a8cf3a32643e7d22851ecafe2506054766408ec82d679f5" => :el_capitan
    sha256 "ee450a5f15b9e51fa3e34478f996379e62fa9e67ba2ca139afef47008adcf793" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    venv = virtualenv_create(libexec)
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
          sha: 5541a6a046b7a0feab73a21612ab5d94a6d3f6f0
          hooks:
          -   id: trailing-whitespace
      EOF
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
