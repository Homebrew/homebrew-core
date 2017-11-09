class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.17.1.tar.gz"
  sha256 "71f7b98af30c12bd4cf69421a09d16edecefb9d0b5e127934c5c832380ea78ba"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "f87a1517e881a92293c447398b9410db31b0e6a2459e08960ac3102a667d6f86" => :high_sierra
    sha256 "c60a9e50c7bf3d5e21e0fd8116f26c0e76f80578cc4cb9b28735f8f3b30c10e1" => :sierra
    sha256 "630d4f6c6a1e318da23de82113b6a13a6570f3a7ea587f40de28bfcd9f582b5a" => :el_capitan
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
