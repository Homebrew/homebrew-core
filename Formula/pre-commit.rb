class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.15.2.tar.gz"
  sha256 "f415d55608ca697b02eadd6160e5e9f496008d41b04a5941ab549277be7e0b76"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3a6248ccef7212cad267df2cb22d922e315d4e77f188db05940eda9b6185c11" => :sierra
    sha256 "8ec98978966775f83b0e3b698be4c5d31114342c783ec64627b1376ec50a72d1" => :el_capitan
    sha256 "5d3f8a585068787fe703d6e9b12189fce7b5d24dc90375896494ebfac9c5e54c" => :yosemite
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
