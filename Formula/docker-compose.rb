class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.24.1.tar.gz"
  sha256 "63a0e0d3819ff77aebd3d5ea30f77b36475ed522c4dabed2eb10636e35aa9370"
  revision 1
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "9abfd3a6d2a68609e72f8bf38bf6ddf54a4ae791a63257ad6907079967bd9dae" => :mojave
    sha256 "ee17fed45db4a209a1ed3c68e30ea395da7ad39cd14cd319944879eca89022c2" => :high_sierra
    sha256 "4c49a9248f46799f22c8d5c90b55a077b543635dbe5f211685c071a83ed0980f" => :sierra
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
