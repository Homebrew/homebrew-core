class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.26.0.tar.gz"
  sha256 "481cd772e3d0592bfc3f076f4a5af11a7c00eda45e2cb61208b1c66b1650d25b"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "cd12694e2bcdc21219c7ec2f0cccf6130a70ec8cc0ab5e70d52945a862266b2f" => :catalina
    sha256 "c653c2767b67475a87b6f52d275dbcdb1de0bf2d56989c6555781a090a1fe81f" => :mojave
    sha256 "0357d87553355e3df806a15292b06693c973a1f0457b536f175c5ee5405db6ed" => :high_sierra
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
