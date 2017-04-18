class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.12.0.tar.gz"
  sha256 "7a51cf38feb6d62e63e124bd6ea5d0de3527a01b997a609ba8b516a829e39b33"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "a2b574e654393ce7590dc987f03b862d53da271413453187e5d759938e37e9d8" => :sierra
    sha256 "c206f3582891337e09e855a6f460e96e6373ba5d7a4b0cb2adf3964037f23d4c" => :el_capitan
    sha256 "9aed20bef54a106586a7b28c90b71d946adc2f7779ce01b5c407b92692290613" => :yosemite
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
