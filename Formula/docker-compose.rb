class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.22.0.tar.gz"
  sha256 "d28a2e96976dae306f480f656e4487a0334a5f95c456408f4bbe4acc5760ffa0"
  revision 2
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "c36f7b6aa865f0e26b574c54bfc6268d8f0969dfcdbbfe9c176f8abd2fa24e76" => :mojave
    sha256 "b07f0d7ea9697b43ea84777a1484ba3e235943f62cc7fe3d926d069d8ab804dc" => :high_sierra
    sha256 "2d4fed6d6fa15a0aacb1fa67b451d645f665b73b82abf4271d9c5187734692cf" => :sierra
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
