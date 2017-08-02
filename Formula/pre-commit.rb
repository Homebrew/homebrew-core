class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.16.0.tar.gz"
  sha256 "15c5d82dd40a97c0b68c83012cd422b6bbf756e2040ee5b24391c43e5fa6370d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a54562cb0f0f239e305d3f791926f5a987b406df715ee949f088aca02d5b923" => :sierra
    sha256 "afc1c27090ed375ec1ac4b453372313f0edd48590c6b8d22362c67019b752d13" => :el_capitan
    sha256 "bfe8c5775e9abe29c7ea66614766cf9beab42e8b56e84bad75b67475bd67a1de" => :yosemite
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
