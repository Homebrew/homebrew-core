class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.1.0.tar.gz"
  sha256 "105a9a941c48e0f90ef4f429e8dbabe2411e1eb74fbda44ff5ed3f31d637a69d"

  bottle do
    cellar :any_skip_relocation
    sha256 "61b3055fad490e5137f45aef82ab2778a65ecc1ba3e4e07c63b5492cf923e91f" => :sierra
    sha256 "46462492f96073cab3bd102aa24cbca81f6a80bf15e4c1b236244fe8a430bc97" => :el_capitan
    sha256 "b6936bdfae9a8259726c3b4b43da0a1abcbf208eb7f24fab430b9c496255904d" => :yosemite
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
