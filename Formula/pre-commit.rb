class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.16.0.tar.gz"
  sha256 "15c5d82dd40a97c0b68c83012cd422b6bbf756e2040ee5b24391c43e5fa6370d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cee697131934dad5f4179a7a55b17c2f0602df46d6b71d5b9a5ca1263805184" => :sierra
    sha256 "cc6724ad19c0bcc4c77bdfdc9c1a1222214048dfafc06ffca5e465bc0ac97b1a" => :el_capitan
    sha256 "22970104e621b42b2f16271bb6fc66e98c3bab2a3472f12f625b860d14ed9690" => :yosemite
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
