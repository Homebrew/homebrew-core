class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.23.2.tar.gz"
  sha256 "18ff12f80e21011e76e04d2579745224316e232a5ca94c79a2865dac5c66eef6"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "97986c5efca02756115ff77623da2ac6209480dceb6f00b23a03e07bbd27acdb" => :mojave
    sha256 "a2214e1996ad9441d7dce56da57f4760146318a3c99e1f1d19f34ca1025c6c5c" => :high_sierra
    sha256 "586d6aa7e35b08410b94bbbfc5ed8e8c9c74d2bc8f2f51a92bf4376254548c60" => :sierra
  end

  depends_on "libyaml"
  depends_on "python"

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec, "python3")
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
