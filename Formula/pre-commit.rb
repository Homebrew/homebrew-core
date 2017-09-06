class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.18.2.tar.gz"
  sha256 "196b1090a7e3ee80314953298ac636c566e87a014398c48e911d9a4c6599e776"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "db3b9e6d9389e08f2f9c6eede0a4ae2c7c888b7550311b820784cb7a31d710e3" => :sierra
    sha256 "8be0c8d61cc4fdf69e610b04b07af4fd165f2c11f8e088a749ed8885ffa617e7" => :el_capitan
    sha256 "4ccd390ef0b87a23e3a28cb079c83161bbe980874756574e721d53cd42656c18" => :yosemite
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
