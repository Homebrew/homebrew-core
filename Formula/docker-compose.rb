class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.26.2.tar.gz"
  sha256 "a4999bcb838ca9e88ff992fedd7a32ab71f97ae081696f8bf26fa1da54aaffe6"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "aada6f245dc719b3d62d4e46ba80698247584bf7022a2aa3329d7abbb845b870" => :catalina
    sha256 "f90d1d546d3e45448398fd8e3b7f45173d45c2989436b9263c6eb6976060a45e" => :mojave
    sha256 "9cf6945b76dbd379d018ff49c53460201e0fc564b75fa6ce20ef71e2e19869d4" => :high_sierra
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
