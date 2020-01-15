class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.25.1.tar.gz"
  sha256 "e48b08d2e94ef011733c5a61b18d7a6b67148e2bf48b375ac1ecb0003fa0c816"
  revision 1
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "1a00d00ba0802424d7e34c80fe8350d28c264fb07c51deab2a78e2caebe1c640" => :catalina
    sha256 "5c5a3469ad1b3477ffd0baa14e828fae93cbaa6de581360531bd71b9540f27e4" => :mojave
    sha256 "a7fcd7bd74e78c40e5535fe9d41ff9b0c81e75726f9e87a25200a6942bcdadf8" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

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
