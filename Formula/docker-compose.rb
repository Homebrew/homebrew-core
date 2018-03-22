class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.20.1.tar.gz"
  sha256 "49a0e2c7a49a5b161c3e74dfdae8173e18174b1fcd8d7675c556a988f0ed95d1"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "23208ef1a3f0cec689b1931a435f4fe03ba4024628094fe5d9181b10bc021dec" => :high_sierra
    sha256 "e4711e432993f9fe2f46374ba13c16859f5a7a9d575a0dac6b0b4279e81e8057" => :sierra
    sha256 "6ab0b18038e8fbcf8bb9abf32d486352620aa6f5fb481779ed02db0046981f3b" => :el_capitan
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
