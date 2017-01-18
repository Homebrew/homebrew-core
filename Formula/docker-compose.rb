class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.10.0.tar.gz"
  sha256 "0277930feaeb03f480914274f65eb419a2ee4b48be9a9fb55a201bb3a14bf290"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "406b178611cb72446c2036995f760ad7f77d6f69e3b03e5d9dcb504e7582da23" => :sierra
    sha256 "8aaeaf8684c22f51e0b00bc9d191d0e3c88cd162dc429b7bc80942b0476d7068" => :el_capitan
    sha256 "6305981f3690b530846bbab3ac87afabffabe18c6678dbe483c3ee6984c86cfc" => :yosemite
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
