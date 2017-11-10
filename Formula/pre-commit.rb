class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.4.1.tar.gz"
  sha256 "cc908bc0ca5f77cdb6d05d090f9b09a18514de8c82dfea3b8edffda06871f0e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "da6cec6492317b167f3c8b809bf7c8571efe632218b7da4a732e05014fa64a21" => :high_sierra
    sha256 "e72184293b058065f9c5a4db11b72230053baa66acc3e5d719f16428fde6d0c4" => :sierra
    sha256 "9ef4ce86d07361ac43c69eb81d8b740835bf8b37127f4829ee0aba0a29033f4b" => :el_capitan
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
