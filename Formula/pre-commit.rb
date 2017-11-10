class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.4.1.tar.gz"
  sha256 "cc908bc0ca5f77cdb6d05d090f9b09a18514de8c82dfea3b8edffda06871f0e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7556ecdd7565a5e087b440903b2f275e1afe584043285f170570af54e643a1b" => :high_sierra
    sha256 "e5b75820d000ddb6a52e27be6086bff48bf6464f518cd342403ad5a6a323d325" => :sierra
    sha256 "0ee9a8a386ef6b87fc348eeb9995479ee412a29b841ce778b773b86ed5656899" => :el_capitan
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pre-commit"
    venv.pip_install_and_link buildpath
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<~EOS
        -   repo: https://github.com/pre-commit/pre-commit-hooks
            sha: v0.9.1
            hooks:
            -   id: trailing-whitespace
      EOS
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
