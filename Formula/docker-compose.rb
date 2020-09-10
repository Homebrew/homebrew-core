class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://files.pythonhosted.org/packages/1a/91/d92394e9c0dcd65f5ea230701227ba0c2786b4659e9058031a5d57478922/docker-compose-1.27.1.tar.gz"
  sha256 "c0e9b630962fc9124d2e0ef6132e67257d6854613739df018a18489cfd0d9afd"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "dc2582bb9fdd34077162655c2563101251515dd763ffdc81abe50fbfa20e3603" => :catalina
    sha256 "55a37ab5af752960225b870f7b1ea756f35e77192f06eaa814be0b839ce6afd8" => :mojave
    sha256 "ddb2c734cde1a98985d2d59522b9bcb51e205d32d31fea9e23be465df23cb618" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  uses_from_macos "libffi"

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
