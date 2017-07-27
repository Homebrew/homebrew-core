class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.15.0.tar.gz"
  sha256 "a2f3fb12a7ac9ecdefbbf9c3c33a7e1e4c033a7cc9eccf74477c393d73191172"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "2a2496601203ededf03840d42f94aac32b67c7a6842b6b25c39961f0df14af00" => :sierra
    sha256 "ef30b83471086bb8d3196a90d820118429c51754236470e0bf0a257f5088032a" => :el_capitan
    sha256 "701ebdde877855f715cbba9bc19f27f03236795c606ae1e83d43b03b6fb5f2bb" => :yosemite
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
