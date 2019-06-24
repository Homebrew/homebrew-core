class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.24.1.tar.gz"
  sha256 "63a0e0d3819ff77aebd3d5ea30f77b36475ed522c4dabed2eb10636e35aa9370"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "2f56cad8904c46f8f9825c9655d8941e8beb29a8ff189437f1c98c6e8a6eb58f" => :mojave
    sha256 "c154b2827f6fb36782917479977243bc6e7b324f988f199a7630486131db092e" => :high_sierra
    sha256 "7fb5e11ffc82fc335cf01975c4147402b193c05d19ecb7f17c000beb8304ada7" => :sierra
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
