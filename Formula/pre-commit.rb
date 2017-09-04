class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.18.1.tar.gz"
  sha256 "fe40fdb7d054b2a6e12babd70678c287d8b66762e0859a3799506a4b350680a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "23adfbde77a36099750388f959d65b6a49d22b84893274bb850cb884db10b964" => :sierra
    sha256 "f318a6f013cca06690f8992890a7d1544336d3b519bb9d9548b27520d967b8cb" => :el_capitan
    sha256 "f653289f84cdd860f635080bdf6d600e15dfa4193a5a3c593271e1b9575cd002" => :yosemite
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
