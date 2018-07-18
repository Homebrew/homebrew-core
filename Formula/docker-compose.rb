class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.22.0.tar.gz"
  sha256 "d28a2e96976dae306f480f656e4487a0334a5f95c456408f4bbe4acc5760ffa0"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "37f5e4b2875a4b5cdab8eb2163e8cdbc7236fe66928bdb72ca7e0ba4ca40c3b2" => :high_sierra
    sha256 "774894a2c375d9775ce08ac73d907a85a6e32dd50d44339048bcb3f933a9d2a5" => :sierra
    sha256 "ad24e287df39d64f9a9c62635f3e48ebca600c6f06549cdf5db53e16ee202af4" => :el_capitan
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
