class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.18.0.tar.gz"
  sha256 "4265c18d7223c149342a252ce6f060934b373a1498c667b4d57b923aaeea4090"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "188d42e482ef48a78e07a3f5203531a4de54e1d8830516da40ab4b82e545aa00" => :high_sierra
    sha256 "62d50dd9e964cd4ac9b1a3606c0d4799bce3740e5c4b733c895c8067abad6d8b" => :sierra
    sha256 "736076c271216a80200400d4f629a3ddbb319d92249ba5dfef9969766ba81079" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
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
