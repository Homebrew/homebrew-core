class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.24.1.tar.gz"
  sha256 "63a0e0d3819ff77aebd3d5ea30f77b36475ed522c4dabed2eb10636e35aa9370"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "fd830417c27771b56440a1a605762df3a97b22daa59c9fd043900ffb56f16353" => :mojave
    sha256 "89d570a0063a45b8ded6f9bd9025bedbda187b46f771c45c8e5cc7bb8df949d7" => :high_sierra
    sha256 "bbd9295a6d411f6733b26aab5c88257d3216beb796d902e49b49369821c341cc" => :sierra
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
