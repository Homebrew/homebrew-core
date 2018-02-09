class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.19.0.tar.gz"
  sha256 "2f8eb50a1e71a9eed773456267d511cd77a463809e746d02d9366888ff30d8a2"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "1b882b7dcf3172146abf3d0c9dde1c76d884da295f730477611ca63f0e118789" => :high_sierra
    sha256 "879edea4c8eb407033c1644ef66701ab780d5f1f2f5d4e9ee3b069257834e769" => :sierra
    sha256 "61b27a9bbed711d265f8eb3d598bf25c4b86bfbff8aab4fe02d0c0039904e97a" => :el_capitan
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
