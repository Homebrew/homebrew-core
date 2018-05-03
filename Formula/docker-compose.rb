class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.21.2.tar.gz"
  sha256 "3fdaa361dceb919b6008a925b8b672d7402cc3dd8277b8f26b028dd546d39926"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "f2fe52ff385c4ceadd14058e728096fa055aefab366152de41960e0724706e8f" => :high_sierra
    sha256 "d561932cdae8452a7bbe8b56afacf5b2857a5a7a9571df00baea4b2460af68d1" => :sierra
    sha256 "7e0833a897aea7581133ed6e4dfcb109de13fc16ebc59d87288a63795cd64ab3" => :el_capitan
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
