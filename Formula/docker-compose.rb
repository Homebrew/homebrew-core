class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.25.4.tar.gz"
  sha256 "844a3d9c9ad13f1227bd828b3693dfb2001dcaea14de7c2a71f8aee47dbf19a7"
  revision 1
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "463bd4a012d5bed971040db53b737bd4c89ae9ee05a14d4d738cf06e9bebd9f9" => :catalina
    sha256 "e3572703ef4cf05000d0eac018b0a01d2d82d7a54941667f2581bfd26e12959f" => :mojave
    sha256 "3c74f2f820c364a88e66667a372fa0c5bf06516e8f0e234b70990cc1cf99fd80" => :high_sierra
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
