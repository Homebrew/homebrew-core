class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.18.0.tar.gz"
  sha256 "4265c18d7223c149342a252ce6f060934b373a1498c667b4d57b923aaeea4090"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "4d7730ec042eb50026d01b4da89e94e2a56d1f9cbdc5d1b9c1cadf72c2f7c412" => :high_sierra
    sha256 "e30d566553106f0d73971cbdc4e7bcdb766ff1f4c44fc618a3ddcc70be8196b1" => :sierra
    sha256 "52b769b83271942eaa8fbeb616258743afd2769462c203ef23389e8c4f1bb0c7" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec)
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
