class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.10.1.tar.gz"
  sha256 "a49b8c8c9319aac96d4729b765524cc6d3aee3a055633d43cfb58695c67b5733"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "05e23608f3fc5184fd6d8fc4ea28b7245170eec1a2776bac212285c43a40e24f" => :sierra
    sha256 "b4b513f6088866eb3fc3e146f86ac3358845b2a3d691830f1caca331ced0f6b6" => :el_capitan
    sha256 "8672869f6f73c1dd39c3fa289c991f9cb0d7eab66f5d06ee09c1ad429e11d471" => :yosemite
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
