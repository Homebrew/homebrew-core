class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.16.1.tar.gz"
  sha256 "3ed32a9ef6a8674df5b6bd4902d7986b2d9732527671e33bee5c9b654e292d4e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cae50965a7bd129099406796679a8b106e4b7c972a5bee44d94139380072334" => :sierra
    sha256 "3db74c00c761d758f06f7ef049a332ebb8c24d091bd49744325b2605dbe588b6" => :el_capitan
    sha256 "31c0669862c5102a4ee30b64e0cbf977f26d41dc3aab7601da2e1665d6b8948e" => :yosemite
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
