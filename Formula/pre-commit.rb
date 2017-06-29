class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.14.3.tar.gz"
  sha256 "fd6244d2e784504b8864ffb073da4844c8552d5c1fd1e467d430c767e7eb20e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f405d64dd1eb6a51e66cdfeefd38eec3db536f3d9d9c591fb3968eb8a5b66399" => :sierra
    sha256 "d1dc26c4d66c4ab32965e853b570e3a6f6cafa499e49bced600a8025b182f4ab" => :el_capitan
    sha256 "dc763effd80bc32e403a7f2107f9c940ef9f505e53ca0a9c252a76c540285110" => :yosemite
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
