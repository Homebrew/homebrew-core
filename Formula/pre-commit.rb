class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.15.0.tar.gz"
  sha256 "04cdffd30f01d38f0faae2d1767490b0fc0c2dd6d28fa4a9a633cca973fe888c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4078f30c86b6a07cb4df7e81a083d4cb9826073760ed73de65293ea9131b6ffc" => :sierra
    sha256 "085351bbf66cd4ca25418af8dc1b28f56555ea5761abf4dc6745a0a0a17a2fff" => :el_capitan
    sha256 "69dc7e5695abcdb2448d9b71edaa92d48fbbe21b1540e29f97a1a688a18fbf1d" => :yosemite
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
