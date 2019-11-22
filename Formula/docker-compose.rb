class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.25.0.tar.gz"
  sha256 "a8abb3b62e1b4e1cce50ee23940b619220226ff2449d4398b27c848b76d2c280"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "9dac324e835fd2d6b5fd2f0fbcdde899d4278578afe85d07779739ff7fd216d4" => :catalina
    sha256 "a15bc3f65ba481e63bb511026bd1deaddb792e70f5d9ef96509ff89688cf7994" => :mojave
    sha256 "7b7cbb154fcb50ce765cb370bf031d59ea25f50662299d4ae6c5e4d657e2481b" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python"

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "docker-compose"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    system bin/"docker-compose", "--help"
  end
end
