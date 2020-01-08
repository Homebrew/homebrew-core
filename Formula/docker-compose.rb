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
    sha256 "01f49b596ea3079dda68ab62677c412770bde48c9d31122375d1377b70f8f250" => :catalina
    sha256 "6e27be9af93212e4b2e4e5de10b79908e25de147aefa7c84267cafe48a17baed" => :mojave
    sha256 "182d04d1b9b1bc66f12cb5c4e8d0b372aadb59ae21190fad282d70cb7ca1bc56" => :high_sierra
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
