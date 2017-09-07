class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.18.3.tar.gz"
  sha256 "ae43eda583fad65a8cc67b793c72f98234bdbb56b1a706349c936fd478af489b"

  bottle do
    cellar :any_skip_relocation
    sha256 "46f0c83421131d1296333e365bae371af36b3660b631ee83281fe4a49a0f7f72" => :sierra
    sha256 "1286b5702cb67a655b786f3d4e9b5804f917ebf38520aa4354443d665f3dbb76" => :el_capitan
    sha256 "2ec0c098d09115e1f74d1f1929598a348a0922c97b0a87a9ccdc643b8ce0c543" => :yosemite
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
