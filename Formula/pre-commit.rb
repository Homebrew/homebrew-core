class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.15.0.tar.gz"
  sha256 "04cdffd30f01d38f0faae2d1767490b0fc0c2dd6d28fa4a9a633cca973fe888c"

  bottle do
    cellar :any_skip_relocation
    sha256 "923c4a3bf9d4a5fd0b62880a634bffa4cf19243187e301d21f8c089d2dd4bf90" => :sierra
    sha256 "9f566be0b50f8c32ae8fbdf7b2c7f3058de32b35859c6bc9b5bcc9969248aa6d" => :el_capitan
    sha256 "719a487d285ef0707e686dbfe38610b57cbf124156fe7b05a5b46d84f922c828" => :yosemite
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
