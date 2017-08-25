class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.17.0.tar.gz"
  sha256 "3e8551049ebb94923099d5882f66359e6a50b22870965ce6c286fbc7eb7e9b21"

  bottle do
    cellar :any_skip_relocation
    sha256 "2199bceb8e0458b66176a4492a04dbd385245dbe02c354a8fbd23e17a88fee41" => :sierra
    sha256 "37e7d2a328119fff3ef9c4517dc8291083f80074c644d239c983ed0404282844" => :el_capitan
    sha256 "dd5167743751c7282f34eda1c6f00ddd16794011d41eb39c21d3358f3ca1da8c" => :yosemite
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
