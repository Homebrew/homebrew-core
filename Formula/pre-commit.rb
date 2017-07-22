class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.15.3.tar.gz"
  sha256 "3066ec3ff22e89b6ee32d569338b341172ed28ad9e09da88de86b7fa8726e8d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "182db157f6679ed22b9afd6d5b8bef43fa364b7f942598c9a32ec293ee67ae64" => :sierra
    sha256 "74b6861bad187bec1a62b740bd084b63171f13ca811bd2e0dda36d64955e0eee" => :el_capitan
    sha256 "18cfe478ed823e2b577147ad74f18a524b5de3a64d2ef9db46c292fccb158baa" => :yosemite
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
