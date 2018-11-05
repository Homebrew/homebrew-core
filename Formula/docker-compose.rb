class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.23.1.tar.gz"
  sha256 "843a458d366ca1d41ceec08b3387ba55c6953eba3a171d6af90db0b01f494312"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "51bacfa01d294dfb81b88a4fbf65074caa4600485079e778baaf716a35c6ab44" => :mojave
    sha256 "5ee9271af248726f39acb843f93ef298d1953049f27bc9943242c97c20435559" => :high_sierra
    sha256 "e52e74369bbaf4a6f25f9272265aed4fa6c6725cde101c1d75cbb82f308c6aca" => :sierra
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
