class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.21.0.tar.gz"
  sha256 "75c954d27f43e6e50f3710f4157abad264d6744f8b96c9edd25569d356b8f596"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "a595da066db4c676a27fcaa9ec7753dff08bbfb3eb22e17c2b0fb221e6490980" => :high_sierra
    sha256 "1d96beb225934f29c36e798f0a59d85ae7bd7e8b076b3281bd81a6ede45c7c81" => :sierra
    sha256 "5bfa8e9f58f77cf7e812cfdb8ed8c5af251d42d0e7faa2cbf9d99df6476d40ad" => :el_capitan
  end

  depends_on "python@2"
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
