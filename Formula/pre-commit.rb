class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.15.4.tar.gz"
  sha256 "237d661da51605ff424ec16f1a99dcb990a041f34ba82ab43da5aaf917f455d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "3485a161d06e099acfec037ab4e5f63ca7171189d7a063ae6dc6122c9c7364b0" => :sierra
    sha256 "861607d2176a1a504779e72a8c1284dad3064608b299ca8e84d7cf917e00b7ba" => :el_capitan
    sha256 "b7c89874ed0705cba4a26f6be83c98ac81494186d2016a8a26d7eb4b7e539343" => :yosemite
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
