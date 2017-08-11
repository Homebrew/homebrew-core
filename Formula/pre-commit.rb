class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.16.3.tar.gz"
  sha256 "9142a3690ae108fb9a66821f745852fd09fab7607ccda34ae70b3d2b6933813a"

  bottle do
    cellar :any_skip_relocation
    sha256 "391e3a533dbf22c0ad04665d1b8385fb8f3d046f2b23c674a9a2330663938ee6" => :sierra
    sha256 "316f7eb419b2bee96dfe817d03a9ba0d803b3dbfcbd5fe1650f18985c17803a2" => :el_capitan
    sha256 "2daece2dce0be5abfcbbfd56e555cc71aa7f3e91d11deae24828c9892c09ceba" => :yosemite
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
