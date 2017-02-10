class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.11.1.tar.gz"
  sha256 "d00a261c08ed664a068a7e72f1a89dc85fc7fb32b9af3dc4b25e414a7b3662e4"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "a94bedf78bc111b54a07cde990a03961bc400fb62e26422a499fc45a07064f6d" => :sierra
    sha256 "c5bc82ed3a2cbfe99fa2d1f6895e2901dc3cd9892e12fb704b6ff5774d6109e7" => :el_capitan
    sha256 "873e04032312891c9c4b2de56593a45579636bc7218964f75e1db9010af41ed9" => :yosemite
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
