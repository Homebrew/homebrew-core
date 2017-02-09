class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.11.0.tar.gz"
  sha256 "71b1040898954a53b14e0823fb4b767b31bc5b355ee7ad1fdf4b2aa393fe2520"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "128e01c0a1785f0534dca8566e8242e486fe4836ecd2d6b50e369085e66a834c" => :sierra
    sha256 "55dd0a74f256048239ba9c982704ca76547e37345213c1d0a3179ffef5299bb2" => :el_capitan
    sha256 "379bd2693ce50294191f652b6a1bd7de05a1098673cca9a8dece7220316684ac" => :yosemite
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
