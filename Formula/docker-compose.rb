class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.11.2.tar.gz"
  sha256 "658a3bf8200499d37b7e7c9701dee5c031da3f22095d75c60d4bdcd7e8f8af9a"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "2f0c95d3cc9cac92265aae462e3994b49dce147acae90b878210764975fd2705" => :sierra
    sha256 "6de9307328dcd59134ef41a1592627afc3392987bcbeac2589dd36303f25997c" => :el_capitan
    sha256 "6d178745ce546d503a1d29237d7f10ba57bd227c4a498377fc59d40d66ade93e" => :yosemite
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
