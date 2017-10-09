class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.3.0.tar.gz"
  sha256 "e4ba7733693c678b17465d5717b26031c5d0a08689ecfbc75887049e99f097de"

  bottle do
    cellar :any_skip_relocation
    sha256 "943f69a727e6c1b9a1187a3399f6a4758d2fc81d99212417a2799d3c7ec0ba47" => :high_sierra
    sha256 "a7fbf4b3782794bbe930a43ee7d7e1728fdd938a853bdd6fea3857171ca0db63" => :sierra
    sha256 "a9e5b9f3b3fa9bedaa6752116049ea4c26ea89c0dc25cdc41c731f54de15499d" => :el_capitan
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
