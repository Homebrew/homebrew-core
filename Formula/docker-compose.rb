class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.14.0.tar.gz"
  sha256 "61d9e9669e1402f77320fbda4e9d3584c201781a9a6061b54a6786f5dcde888f"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "9421b63ff9b56408ccaf08771a848e640ced97f01af61dfe377ed542448c5bdb" => :sierra
    sha256 "8930a919235ba5cf92c31a1517268f1442ea64335e8cf1e0146174fccb5c59af" => :el_capitan
    sha256 "bfebd3632622d3b45f370c55c000316632e99201d4543cde221884e463babf6a" => :yosemite
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
