class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.18.0.tar.gz"
  sha256 "6485cbd3dfc6c94179e0be3d8b4a0288452bf90149f1d4db81b9a6851610afb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "abb8368790f5971a3339c170cf7c80d0b6d253d0d97032535b3b5995bc43817a" => :sierra
    sha256 "02eb7cf667223976ba72f6fd65a0a7e68dfee4f21ede7bceb4e157c5a8a2229d" => :el_capitan
    sha256 "2d50a09c84ee2bf69776ec7bb34cfc7ad43c5f66ac5cf8b816256b12c48ec018" => :yosemite
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
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
      EOF
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
