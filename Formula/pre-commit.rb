class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.18.2.tar.gz"
  sha256 "196b1090a7e3ee80314953298ac636c566e87a014398c48e911d9a4c6599e776"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee4ddbacc89f26232a49fc98452bba97b1db843bca6206452b7567178005ffc1" => :sierra
    sha256 "986c015994f9906c3ecaf42d72a8385e267a14fdd4ea14debbac6765b270f46b" => :el_capitan
    sha256 "c8d58439f6b593ddcd9914c41a559dfc950c5b4729a3aa70931c3f446961b15a" => :yosemite
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
