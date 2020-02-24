class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.25.4.tar.gz"
  sha256 "844a3d9c9ad13f1227bd828b3693dfb2001dcaea14de7c2a71f8aee47dbf19a7"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "ebe367f2fb704314ae2875d865c40c9b8b1e870cf888742c99216356f114961f" => :catalina
    sha256 "54f367f476359b1a12e8b0f23fc9a7583732f2bd678ab031fd6ea980350dbad3" => :mojave
    sha256 "ef81d6ad5b72e9fc2233e0f314d7b71eb20a9641e763957a2a1b2adc594791cf" => :high_sierra
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
