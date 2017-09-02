class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.16.1.tar.gz"
  sha256 "c1a0416f4fc1fb83471dd9151e4dfafb835741af05a503f2784627d5fc4bbf15"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "77548febb101ecc54a5873eabbf384886cd76c1c59e9e549c73e7b326776c8eb" => :sierra
    sha256 "656715a5f47d27414245069e59ec02880793d9d859527a6bf0b8f8d3a4aaeb53" => :el_capitan
    sha256 "5d901e924bf3022a5b1ec75e9115431f5420e92e7acd03a2a494fb8784739068" => :yosemite
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
