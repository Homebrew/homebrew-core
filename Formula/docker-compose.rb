class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.20.1.tar.gz"
  sha256 "49a0e2c7a49a5b161c3e74dfdae8173e18174b1fcd8d7675c556a988f0ed95d1"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "93b0e938eec41909919bd4f3055d451b81e9ee68ba6e482d8a143c3e294ab3d9" => :high_sierra
    sha256 "4e9a5f52fc36354a7d0647fd97b7ae9d1ededad1de4525eef1ca945bf79d1147" => :sierra
    sha256 "7cbf432cc824fa4db0dbca88a7b18b14d8402a0e8828f53a5da9f15016eedaaa" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard
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
