class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.12.0.tar.gz"
  sha256 "7a51cf38feb6d62e63e124bd6ea5d0de3527a01b997a609ba8b516a829e39b33"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "8360419124615b67bee9b558e7cfe0e068c092d04ea962093385bef69a871c22" => :sierra
    sha256 "bc25dfdf5c19a2302382ff362fe723805761dabc48a3dcb88b941afddde02c35" => :el_capitan
    sha256 "09702f237d139354202642ac9249ea7dcde172599b8703ba68942ce5982db5d5" => :yosemite
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
